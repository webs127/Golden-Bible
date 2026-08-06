import 'dart:convert';

import 'package:bible/core/models/save.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  final SharedPreferences _prefs;
  final List<Bookmark> _bookmarks = [];
  final List<Highlight> _highlights = [];
  final List<Notes> _notes = [];

  static const _bookmarksKey = 'saved_bookmarks';
  static const _highlightsKey = 'saved_highlights';
  static const _notesKey = 'saved_notes';

  SaveService(this._prefs) {
    _load();
  }

  void _load() {
    _bookmarks.addAll(_decodeBookmarks(_prefs.getString(_bookmarksKey)));
    _highlights.addAll(_decodeHighlights(_prefs.getString(_highlightsKey)));
    _notes.addAll(_decodeNotes(_prefs.getString(_notesKey)));
  }

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  List<Highlight> get highlights => List.unmodifiable(_highlights);
  List<Notes> get notes => List.unmodifiable(_notes);

  void addBookmark(Bookmark bookmark) {
    _bookmarks.add(bookmark);
    _persistBookmarks();
  }

  void removeBookmark(int index) {
    _bookmarks.removeAt(index);
    _persistBookmarks();
  }

  void addHighlight(Highlight highlight) {
    _highlights.add(highlight);
    _persistHighlights();
  }

  void removeHighlight(int index) {
    _highlights.removeAt(index);
    _persistHighlights();
  }

  void addNote(Notes note) {
    _notes.add(note);
    _persistNotes();
  }

  void removeNote(int index) {
    _notes.removeAt(index);
    _persistNotes();
  }

  void _persistBookmarks() {
    _prefs.setString(
      _bookmarksKey,
      jsonEncode(_bookmarks.map((b) => b.toJson()).toList()),
    );
  }

  void _persistHighlights() {
    _prefs.setString(
      _highlightsKey,
      jsonEncode(_highlights.map((h) => h.toJson()).toList()),
    );
  }

  void _persistNotes() {
    _prefs.setString(
      _notesKey,
      jsonEncode(_notes.map((n) => n.toJson()).toList()),
    );
  }

  List<Bookmark> _decodeBookmarks(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final list = _tryDecode(raw);
    return list == null ? [] : list.map(Bookmark.fromJson).toList();
  }

  List<Highlight> _decodeHighlights(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final list = _tryDecode(raw);
    return list == null ? [] : list.map(Highlight.fromJson).toList();
  }

  List<Notes> _decodeNotes(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final list = _tryDecode(raw);
    return list == null ? [] : list.map(Notes.fromJson).toList();
  }

  List<Map<String, dynamic>>? _tryDecode(String raw) {
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (_) {
      return null;
    }
  }
}
