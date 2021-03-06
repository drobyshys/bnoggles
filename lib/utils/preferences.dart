// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The preferences as set by the user.
class Preferences {
  Preferences._({
    @required this.language,
    @required this.numberOfPlayers,
    @required this.hasTimeLimit,
    @required this.time,
    @required this.boardWidth,
    @required this.minimalWordLength,
    @required this.hints,
  });

  /// The code of the language in which the game is played.
  final ValueNotifier<int> language;

  /// The number of players
  final ValueNotifier<int> numberOfPlayers;

  /// Flag for having a limited time for the game
  final ValueNotifier<bool> hasTimeLimit;

  /// The time in seconds the game will last
  final ValueNotifier<int> time;

  /// The width of the [Board]
  final ValueNotifier<int> boardWidth;

  /// The minimal length of the words to be found
  final ValueNotifier<int> minimalWordLength;

  /// Flag whether or not hints are shown
  final ValueNotifier<bool> hints;

  /// Returns the Preferences.
  ///
  /// The previous set preferences are restored from the [SharedPreferences].
  static Future<Preferences> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ValueNotifier<int> intNotifier(String name, int defaultValue) {
      int value = prefs.getInt(name) ?? defaultValue;
      ValueNotifier<int> result = ValueNotifier(value);
      result.addListener(() => prefs.setInt(name, result.value));
      return result;
    }

    ValueNotifier<bool> boolNotifier(String name, bool defaultValue) {
      bool value = prefs.getBool(name) ?? defaultValue;
      ValueNotifier<bool> result = ValueNotifier(value);
      result.addListener(() => prefs.setBool(name, result.value));
      return result;
    }

    return Preferences._(
      language: intNotifier('language', 0),
      numberOfPlayers: intNotifier('numberOfPlayers', 1),
      hasTimeLimit: boolNotifier('hasTimeLimit', true),
      time: intNotifier('time', 150),
      boardWidth: intNotifier('size', 3),
      minimalWordLength: intNotifier('length', 2),
      hints: boolNotifier('hints', false),
    );
  }

  /// Creates [GameParameters] based on these Preferences
  GameParameters toParameters() => GameParameters._(
        languageCode: const ['nl', 'en', 'hu'][language.value],
        numberOfPlayers: numberOfPlayers.value,
        hasTimeLimit: hasTimeLimit.value,
        time: time.value,
        boardWidth: boardWidth.value,
        minimalWordLength: minimalWordLength.value,
        hints: hints.value,
      );

  @override
  String toString() =>
      'Preferences [${language.value}, ${time.value}, ${boardWidth.value}, '
      '${minimalWordLength.value}, ${hints.value}]';
}

/// Parameters to start a new game with
class GameParameters {
  const GameParameters._({
    @required this.languageCode,
    @required this.numberOfPlayers,
    @required this.hasTimeLimit,
    @required this.time,
    @required this.boardWidth,
    @required this.minimalWordLength,
    @required this.hints,
  });

  /// The code of the language in which the game is played
  final String languageCode;

  /// The number of players
  final int numberOfPlayers;

  /// Flag for having a limited time for the game
  final bool hasTimeLimit;

  /// The time in seconds the game will last
  final int time;

  /// The width of the [Board]
  final int boardWidth;

  /// The minimal length of the words to be found
  final int minimalWordLength;

  /// Flag whether or not hints are shown
  final bool hints;
}

/// Provider for [GameParameters]
typedef GameParameters ParameterProvider();
