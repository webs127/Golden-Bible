import 'package:bible/core/models/save.dart';
import 'package:bible/services/save_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedProvider with ChangeNotifier {
  final SaveService saveService;

  List<Bookmark> bookmarks = [];
  List<Highlight> highlights = [];
  List<Notes> notes = [];

  bool get isBookmarkEmpty => bookmarks.isEmpty;
  int get bookmarkLength => bookmarks.length;

  bool get isHighlightsEmpty => highlights.isEmpty;
  int get highlightsLength => highlights.length;

  bool get isNotesEmpty => notes.isEmpty;
  int get notesLength => notes.length;

  SavedProvider(SharedPreferences prefs)
    : saveService = SaveService(prefs) {
    bookmarks = saveService.bookmarks;
    highlights = saveService.highlights;
    notes = saveService.notes;
  }

  void addBookmark(Bookmark bookmark) {
    saveService.addBookmark(bookmark);
    bookmarks = saveService.bookmarks;
    notifyListeners();
  }

  void removeBookmark(int index) {
    saveService.removeBookmark(index);
    bookmarks = saveService.bookmarks;
    notifyListeners();
  }

  void addHighlight(Highlight highlight) {
    saveService.addHighlight(highlight);
    highlights = saveService.highlights;
    notifyListeners();
  }

  void removeHighlight(int index) {
    saveService.removeHighlight(index);
    highlights = saveService.highlights;
    notifyListeners();
  }

  void addNote(Notes note) {
    saveService.addNote(note);
    notes = saveService.notes;
    notifyListeners();
  }

  void removeNote(int index) {
    saveService.removeNote(index);
    notes = saveService.notes;
    notifyListeners();
  }
}
