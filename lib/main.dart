import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, rootBundle;

import 'package:bnoggles/screens/start/start_screen.dart';

import 'package:bnoggles/utils/dictionary.dart';

void main() async {
  var res = await setup();

  runApp(MyApp(res));
}

Future<Configuration> setup() async {
  String configJson = await loadConfigJson();
  Map<String, dynamic> config = json.decode(configJson);

  Map<String, int> _freq = getFreq(config);
  var generator = RandomLetterGenerator(_freq);

  String words = await loadDictionary();
  Dictionary dict = Dictionary(words.split("\n")..sort());

  return Configuration(generator, dict);
}

Map<String, int> getFreq(Map<String, dynamic> config) {
  var result = <String, int>{};
  Map<String, dynamic> m = config['letterFrequencies'];
  m.forEach((k, dynamic e) => result[k] = e as int);

  return result;
}

Future<String> loadConfigJson() async {
  return await rootBundle.loadString('assets/config.json');
}

Future<String> loadDictionary() async {
  return await rootBundle.loadString('assets/words-nl.txt');
}

Future<Dictionary> readDutchWords(String fileName) async {
  var source = File(fileName);
  List<String> contents = await source.readAsLines();
  contents.sort();
  return Dictionary(contents);
}

class Configuration {
  final RandomLetterGenerator generator;
  final Dictionary dictionary;

  Configuration(this.generator, this.dictionary);
}

class MyApp extends StatelessWidget {
  final Configuration configuration;

  MyApp(this.configuration);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Bnoggles',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StartScreen(
          dictionary: configuration.dictionary,
          generator: configuration.generator),
    );
  }
}
