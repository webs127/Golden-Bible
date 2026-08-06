import 'dart:convert';
import 'package:bible/core/models/bible.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DataService {
  // In-memory cache variables
  Bible? _cachedBibleData;
  bool _isLoaded = false;

  // 1. Load data into memory immediately from Flutter assets
  Future<void> preloadData(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      var bibleList = jsonDecode(jsonString);
      Bible bible = Bible.fromJson(bibleList);
      debugPrint(bible.toString());
     _cachedBibleData = bible;
      _isLoaded = true;
    } catch (e) {
      debugPrint('Failed to preload data: $e');
    }
  }

  // 2. Use the data instantly without re-reading the file
  Bible? get data {
    if (!_isLoaded) {
      debugPrint('Warning: Data was not preloaded.');
    }
    return _cachedBibleData;
  }
}

