// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:quiver/core.dart';

abstract class Affix {
  Affix(this._combinable, this._toAdd);

  final bool _combinable;
  final String _toAdd;

  bool canBeAppliedTo(String word);

  String apply(String word);
}

class Prefix extends Affix {
  Prefix(bool _combinable, String toAdd) : super(_combinable, toAdd);

  @override
  String apply(String text) => _toAdd + text;

  @override
  bool canBeAppliedTo(String word) => true;

  @override
  bool operator ==(dynamic other) => other is Prefix && other._toAdd == _toAdd;

  @override
  int get hashCode => _toAdd.hashCode;

  @override
  String toString() => "PFX $_toAdd";
}

class Suffix extends Affix {
  Suffix(bool _combinable, String toAdd, this._toStrip, this._condition)
      : super(_combinable, toAdd);

  final int _toStrip;
  final SuffixCondition _condition;

  @override
  bool canBeAppliedTo(String word) => _condition.match(word);

  @override
  String apply(String text) =>
      text.substring(0, text.length - _toStrip) + _toAdd;

  @override
  bool operator ==(dynamic other) =>
      other is Suffix &&
      other._toAdd == _toAdd &&
      other._toStrip == _toStrip &&
      other._condition == _condition;

  @override
  int get hashCode =>
      hash3(_toAdd.hashCode, _toStrip.hashCode, _condition.hashCode);

  @override
  String toString() => "SFX $_toAdd $_toStrip $_condition";
}

class SuffixCondition {
  const SuffixCondition(this._pattern);
  final String _pattern;

  bool match(String word) {
    if (_pattern.isEmpty) return true;

    return RegExp(_pattern + '\$').hasMatch(word);
  }

  @override
  bool operator ==(dynamic other) =>
      other is SuffixCondition && _pattern == other._pattern;

  @override
  int get hashCode => _pattern.hashCode;
}

const SuffixCondition emptyCondition = SuffixCondition("");

class AffixedWordContainer {
  AffixedWordContainer(this._base, this._prefixes, this._suffixes);

  final String _base;
  final List<Affix> _prefixes;
  final List<Affix> _suffixes;

  List<Affix> _combinablePrefixes() =>
      _prefixes.where((e) => e._combinable).toList();
  List<Affix> _combinableSuffixes() =>
      _suffixes.where((e) => e._combinable).toList();
  List<Affix> _uncombinablePrefixes() =>
      _prefixes.where((e) => !e._combinable).toList();
  List<Affix> _uncombinableSuffixes() =>
      _suffixes.where((e) => !e._combinable).toList();

  int get length => _combinableLength() + _uncombinableLength();

  int _combinableLength() =>
      (_combinablePrefixes().length + 1) * (_combinableSuffixes().length + 1);

  int _uncombinableLength() =>
      _uncombinablePrefixes().length + _uncombinableSuffixes().length;

  String _word(int index) => index < _combinableLength()
      ? wordFromCombinables(index)
      : wordFromUncombinables(index);

  String wordFromCombinables(int index) {
    int rowLength = _prefixes.length + 1;
    int y = (index / rowLength).floor();
    int x = index - y * rowLength;

    String result = _base;
    if (x > 0) {
      result = _prefixes[x - 1].apply(result);
    }
    if (y > 0) {
      result = _suffixes[y - 1].apply(result);
    }

    return result;
  }

  String wordFromUncombinables(int index) {
    int rest = index - _combinableLength();
    var uncombinablePrefixes = _uncombinablePrefixes();
    if (rest < uncombinablePrefixes.length) {
      return uncombinablePrefixes[rest].apply(_base);
    }

    rest -= uncombinablePrefixes.length;
    return _uncombinableSuffixes()[rest].apply(_base);
  }

  @override
  String toString() => '$_base $_prefixes $_suffixes';
}

class AffixedWord implements Comparable<AffixedWord> {
  AffixedWord(this._container, this._index);

  final AffixedWordContainer _container;
  final int _index;

  @override
  int compareTo(AffixedWord other) =>
      _container._word(_index).compareTo(other._container._word(other._index));

  @override
  String toString() => _container._word(_index);
}
