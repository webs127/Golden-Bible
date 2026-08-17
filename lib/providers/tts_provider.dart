import 'package:bible/core/models/bible.dart';
import 'package:bible/services/tts_service.dart';
import 'package:flutter/material.dart';

enum PlayMode { chapter, singleVerse }

class TtsProvider extends ChangeNotifier {
  final TtsService _tts = TtsService.instance;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int _currentVerseIndex = 0;
  int get currentVerseIndex => _currentVerseIndex;

  CurrentBook? _currentBook;
  CurrentBook? get currentBook => _currentBook;

  PlayMode _playMode = PlayMode.chapter;
  PlayMode get playMode => _playMode;

  double _speechRate = 0.5;
  static const double _minRate = 0.1;
  static const double _maxRate = 1.0;
  static const double _rateStep = 0.1;
  double get speechRate => _speechRate;

  static const List<double> speedPresets = [0.5, 0.8, 1.0, 1.2, 1.5];

  int get totalVerses => _currentBook?.verses.length ?? 0;

  String get currentVerseText {
    final book = _currentBook;
    if (book == null || _currentVerseIndex >= book.verses.length) return '';
    return book.verses[_currentVerseIndex];
  }

  String get currentVerseReference {
    final book = _currentBook;
    if (book == null) return '';
    return '${book.name} ${book.chapter}:${_currentVerseIndex + 1}';
  }

  Future<void> init() async {
    await _tts.init();
    _tts.setCompletionHandler(() {
      _onVerseComplete();
    });
    _tts.setCancelHandler(() {
      _isPlaying = false;
      notifyListeners();
    });
  }

  void _onVerseComplete() {
    if (_playMode == PlayMode.chapter) {
      if (_currentVerseIndex < totalVerses - 1) {
        _currentVerseIndex++;
        notifyListeners();
        _speakCurrentVerse();
      } else {
        _isPlaying = false;
        _currentVerseIndex = 0;
        notifyListeners();
      }
    } else {
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> _speakCurrentVerse() async {
    final text = currentVerseText;
    if (text.isNotEmpty) {
      await _tts.speak(text);
    } else {
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> playChapter(CurrentBook book) async {
    await stop();
    _currentBook = book;
    _playMode = PlayMode.chapter;
    _currentVerseIndex = 0;
    _isPlaying = true;
    notifyListeners();
    await _speakCurrentVerse();
  }

  Future<void> playSingleVerse(CurrentBook book, int verseIndex) async {
    await stop();
    _currentBook = book;
    _playMode = PlayMode.singleVerse;
    _currentVerseIndex = verseIndex.clamp(0, book.verses.length - 1);
    _isPlaying = true;
    notifyListeners();
    await _speakCurrentVerse();
  }

  Future<void> togglePlayPause([CurrentBook? book]) async {
    if (_currentBook == null && book == null) return;
    if (_isPlaying) {
      await _tts.pause();
      _isPlaying = false;
    } else {
      if (_currentBook == null) {
        _currentBook = book;
        _currentVerseIndex = 0;
      }
      if (currentVerseText.isEmpty) return;
      await _tts.speak(currentVerseText);
      _isPlaying = true;
    }
    notifyListeners();
  }

  Future<void> nextVerse() async {
    if (_currentBook == null) return;
    if (_currentVerseIndex < totalVerses - 1) {
      final wasPlaying = _isPlaying;
      await _tts.stop();
      _currentVerseIndex++;
      notifyListeners();
      if (wasPlaying) {
        await _speakCurrentVerse();
      }
    }
  }

  Future<void> prevVerse() async {
    if (_currentBook == null) return;
    if (_currentVerseIndex > 0) {
      final wasPlaying = _isPlaying;
      await _tts.stop();
      _currentVerseIndex--;
      notifyListeners();
      if (wasPlaying) {
        await _speakCurrentVerse();
      }
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void setPlayMode(PlayMode mode) {
    _playMode = mode;
    notifyListeners();
  }

  void togglePlayMode() {
    _playMode = _playMode == PlayMode.chapter
        ? PlayMode.singleVerse
        : PlayMode.chapter;
    notifyListeners();
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(_minRate, _maxRate);
    await _tts.setSpeechRate(_speechRate);
    notifyListeners();
  }

  void increaseSpeed() {
    final newRate = (_speechRate + _rateStep).clamp(_minRate, _maxRate);
    setSpeechRate(newRate);
  }

  void decreaseSpeed() {
    final newRate = (_speechRate - _rateStep).clamp(_minRate, _maxRate);
    setSpeechRate(newRate);
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }
}
