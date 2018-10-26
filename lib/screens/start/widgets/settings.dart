import 'package:bnoggles/screens/start/widgets/board_size_slider.dart';
import 'package:bnoggles/screens/start/widgets/length_slider.dart';
import 'package:bnoggles/screens/start/widgets/time_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsGrid extends StatelessWidget {
  final ValueNotifier<int> _time;
  final ValueNotifier<int> _size;
  final ValueNotifier<int> _length;

  SettingsGrid(this._time, this._size, this._length);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(25.0),
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(50.0),
            1: FixedColumnWidth(60.0),
            2: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(child: TimeIcon()),
                TableCell(child: TimeText(time: _time)),
                TableCell(child: TimeSlider()),
              ],
            ),
            TableRow(
              children: [
                Container(height: 50.0),
                Container(),
                Container(),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: BoardIcon()),
                TableCell(child: BoardText(size: _size)),
                TableCell(child: BoardSizeSlider()),
              ],
            ),
            TableRow(
              children: [
                Container(height: 50.0),
                Container(),
                Container(),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: LengthIcon()),
                TableCell(child: LengthText(length: _length)),
                TableCell(child: LengthSlider()),
              ],
            ),
            TableRow(
              children: [
                Container(height: 50.0),
                Container(),
                Container(),
              ],
            ),
          ],
        ));
  }
}
