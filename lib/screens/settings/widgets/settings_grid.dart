// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:bnoggles/screens/settings/widgets/language_setting.dart';
import 'package:bnoggles/screens/settings/widgets/toggle_setting.dart';
import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// The height of an empty line should decrease for smaller screen sizes. The
// maximum height is 50. Empirically found values for the height of some
// devices are:
//
// - for screen height 592.0 (e.g. Nexus 4) the empty line height is 20
// - for screen height 683.4 (e.g. Pixel) the empty line height is 50
final emptyLineHeightCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 20),
  p2: const Point(683.4, 50),
  min: 0,
  max: 50,
);

/// A widget displaying all settings.
class SettingsGrid extends StatelessWidget {
  /// Creates a [SettingsGrid] based on the given [Preferences].
  SettingsGrid(this._preferences);
  final Preferences _preferences;

  TableRow _emptyLine(double emptyLineHeight) => TableRow(
        children: [
          Container(height: emptyLineHeight),
          Container(),
          Container(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // See above
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;
    double emptyLineHeight = emptyLineHeightCalculator.y(x: screenHeight);

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(5.0),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(50.0),
          1: FixedColumnWidth(60.0),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: languageOptions(
              notifier: _preferences.language,
              icon: Icons.language,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: intSlider(
              switchNotifier: _preferences.hasTimeLimit,
              sliderNotifier: _preferences.time,
              icon: Icons.timer,
              label: formatTime,
              min: 30,
              max: 600,
              stepSize: 30,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: intSlider(
              sliderNotifier: _preferences.boardWidth,
              icon: Icons.grid_on,
              label: (i) => '$i x $i',
              min: 3,
              max: 6,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: intSlider(
              sliderNotifier: _preferences.minimalWordLength,
              icon: Icons.text_rotation_none,
              label: (i) => '$i+',
              min: 2,
              max: 4,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: toggleSetting(
              icon: Icons.assistant,
              notifier: _preferences.hints,
            ),
          ),
        ],
      ),
    );
  }
}
