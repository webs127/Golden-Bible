import 'package:bible/core/models/devotion.dart';
import 'package:bible/services/devotional_service.dart';
import 'package:flutter/material.dart';

class DevotionalProvider with ChangeNotifier {
  final DevotionalService _devotionalService = DevotionalService();
  DevotionalList? devotionalList;
  Devotion? devotion;

  DevotionalProvider() {
    _loadDevotionals();
  }

  int get length => _devotionalService.devotionalsLength;

  Future<void> _loadDevotionals() async {
    await _devotionalService.preloadData('assets/json/devotional.json');
    devotionalList = _devotionalService.devotionalList!;
    devotion = _devotionalService.devotion;
    notifyListeners();
  }
}
