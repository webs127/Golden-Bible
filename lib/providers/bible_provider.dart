import 'package:bible/core/models/bible.dart';
import 'package:bible/core/models/match.dart';
import 'package:bible/services/load_bible.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleProvider with ChangeNotifier {
  static const _currentBibleKey = 'current_bible';
  static const _textSizeKey = 'text_size';
  static const _fontWeightKey = 'font_weight';

  final SharedPreferences _prefs;
  final kjvService = DataService();
  final bbeService = DataService();
  Bible? kjvBible;
  Bible? bbeBible;
  int currentBible;
  List<Bible?> _bibles = [];
  bool isLoading = true;
  List<bool> versesOptions = [];
  double textSize;
  FontWeight fontWeight;

  BibleProvider(this._prefs)
    : currentBible = _prefs.getInt(_currentBibleKey) ?? 0,
      textSize = _prefs.getDouble(_textSizeKey) ?? 14,
      fontWeight = _fontWeightFromValue(_prefs.getInt(_fontWeightKey) ?? 400) {
    _loadBible();
  }

  static FontWeight _fontWeightFromValue(int value) {
    return FontWeight.values.firstWhere(
      (fontWeight) => fontWeight.value == value,
      orElse: () => FontWeight.normal,
    );
  }

  Future<void> _loadBible() async {
    await kjvService.preloadData('assets/json/en_kjv.json');
    await bbeService.preloadData('assets/json/en_bbe.json');
    kjvBible = kjvService.data;
    bbeBible = bbeService.data;
    isLoading = false;
    _bibles = [kjvBible, bbeBible];
    notifyListeners();
  }

  Bible? get bible => _bibles[currentBible];

  int _length = 0;

  set versesLength(int value) {
    // Only (re)initialize the options list when the length actually changes.
    if (_length != value) {
      _length = value;
      versesOptions = List.filled(_length, false);
      notifyListeners();
    }
  }

  changeVerseOptionState(int index) {
    if (index >= 0 && index < versesOptions.length) {
      versesOptions[index] = !versesOptions[index];
      notifyListeners();
    }
  }

  Book? _findBookByName(String bookName) {
    final bible = this.bible;
    if (bible == null) return null;

    final query = bookName.toLowerCase();
    for (final book in bible.books) {
      if (book.name.toLowerCase() == query ||
          book.abbrev.toLowerCase() == query) {
        return book;
      }
    }
    return null;
  }

  CurrentBook getCurrentBook(CurrentBook currentBook) {
    final matchedBook = _findBookByName(currentBook.name);
    if (matchedBook == null ||
        matchedBook.chapters.isEmpty ||
        currentBook.chapter < 1 ||
        currentBook.chapter > matchedBook.chapters.length) {
      return currentBook;
    }

    return CurrentBook(
      name: matchedBook.name,
      chapter: currentBook.chapter,
      verses: matchedBook.chapters[currentBook.chapter - 1].verses,
    );
  }

  Book? getActiveBook(CurrentBook currentBook) {
    return _findBookByName(currentBook.name);
  }

  onBibleChanged(int? value, CurrentBook currentBook) {
    if (value == null) return;
    currentBible = value;
    _prefs.setInt(_currentBibleKey, currentBible);
    final activeBook = getCurrentBook(currentBook);
    versesLength = activeBook.verses.length;
    notifyListeners();
  }

  onTextSizeChanged(double value) {
    textSize = value;
    _prefs.setDouble(_textSizeKey, textSize);
    notifyListeners();
  }

  onFontWeightChanged(FontWeight? value) {
    if (value == null) {
      return;
    }
    fontWeight = value;
    _prefs.setInt(_fontWeightKey, fontWeight.value);
    notifyListeners();
  }

  List<SearchMatch> _searchResults = [];
  List<SearchMatch> get searchResults => _searchResults;

  void searchWord(String valueToSearch) {
    valueToSearch = valueToSearch.trim().toLowerCase();

    List<SearchMatch> results = [];
    Set<String> seen = {};
    final books = bible?.books ?? [];

    if (valueToSearch.isEmpty) {
      _searchResults = [];
      pageLength = 0;
      currentPage = 0;
      remainder = 0;
      block = 0;
      notifyListeners();
      return;
    }

    for (var i = 0; i < books.length; i++) {
      Book book = books[i];
      for (var j = 0; j < book.chapters.length; j++) {
        Chapters chapter = book.chapters[j];
        for (var k = 0; k < chapter.verses.length; k++) {
          String verse = chapter.verses[k];
          if (verse.toLowerCase().contains(valueToSearch)) {
            if (!seen.contains(verse)) {
              results.add(
                SearchMatch(
                  book: book.name,
                  chapter: j + 1,
                  verse: verse,
                  verseIndex: k + 1,
                  bookIndex: i + 1,
                ),
              );
              seen.add(verse);
            }
          }
        }
      }
    }

    _searchResults = results;
    pageLength = _searchResults.length;
    currentPage = 0;
    calculatePageBlock();
    notifyListeners();
  }

  onChanged(String value) => searchWord(value);

  int tilePerPage = 10;
  int currentPage = 0;
  int pageLength = 0;
  int remainder = 0;
  int block = 0;

  calculatePageBlock() {
    block = pageLength ~/ tilePerPage;
    remainder = pageLength % tilePerPage;
  }

  bool get isRemainderEmpty => remainder == 0;

  int get totalPages => isRemainderEmpty ? block : block + 1;

  onPageSelected(int value) {
    if (totalPages == 0) return;
    if (value < 0) value = 0;
    if (value >= totalPages) value = totalPages - 1;
    currentPage = value;
    notifyListeners();
  }
}
