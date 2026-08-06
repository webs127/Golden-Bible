import 'dart:convert';

import 'package:bible/core/models/devotion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DevotionalService {
  DevotionalList? _devotionalList;
  bool _isLoaded = false;
  int devotionalsLength = 0;
  
  Devotion? devotion;

  Future<void> preloadData(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      var bibleList = jsonDecode(jsonString);
      DevotionalList devList = DevotionalList.fromJson(bibleList);
      debugPrint(devList.toString());
      _devotionalList = devList;
      _isLoaded = true;
    } catch (e) {
      debugPrint('Failed to preload data: $e');
    }
  }

  DevotionalList? get devotionalList {
    if (!_isLoaded) {
      debugPrint('Warning: Data was not preloaded.');
    }
    devotionalsLength = _devotionalList!.devotionals.length;
    randomize();
    return _devotionalList;
  }

  void randomize() {
    devotion = verseForDate(DateTime.now());
  }

  Devotion verseForDate(DateTime date) {
    final list = _devotionalList!;
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final index = dayOfYear % list.devotionals.length;
    return list.devotionals[index];
  }
}
