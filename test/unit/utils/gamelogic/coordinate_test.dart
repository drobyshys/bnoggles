// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';

void main() {
  var origin = Coordinate(0, 0);

  test('+', () {
    expect(origin + Coordinate(0, -1), Coordinate(0, -1));
    expect(origin + Coordinate(1, 0), Coordinate(1, 0));
    expect(origin + Coordinate(1, 5), Coordinate(1, 5));
  });

  test('allNeighbours simple', () {
    var neighbours = [
      Coordinate(0, -1),
      Coordinate(1, -1),
      Coordinate(1, 0),
      Coordinate(1, 1),
      Coordinate(0, 1),
      Coordinate(-1, 1),
      Coordinate(-1, 0),
      Coordinate(-1, -1),
    ];

    testEqualSets(origin.allNeighbours(-10, 10), neighbours);
  });

  test('allNeighbours with restrictions', () {
    var neighbours = [
      Coordinate(1, 0),
      Coordinate(1, 1),
      Coordinate(0, 1),
    ];

    testEqualSets(origin.allNeighbours(0, 10), neighbours);
  });

  test('isNeighbourOf', () {
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(0, -1)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(1, -1)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(1, 0)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(1, 1)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(0, 1)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(-1, 1)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(-1, 0)), true);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(-1, -1)), true);

    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(0, 0)), false);

    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(2, 0)), false);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(0, 2)), false);
    expect(Coordinate(0, 0).isNeighbourOf(Coordinate(2, 2)), false);
  });
}

void testEqualSets(Iterable actual, Iterable matcher) {
  expect(actual.toSet(), matcher.toSet());
}
