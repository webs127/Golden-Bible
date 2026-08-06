class Bookmark {
  final String book;
  final int chapter;
  final int verse;
  final String value;
  final String date;

  Bookmark({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.value,
    String? date,
  }) : date = date ?? _formatDate(DateTime.now());

  Map<String, dynamic> toJson() => {
    'book': book,
    'chapter': chapter,
    'verse': verse,
    'value': value,
    'date': date,
  };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    book: json['book'] as String,
    chapter: json['chapter'] as int,
    verse: json['verse'] as int,
    value: json['value'] as String,
    date: json['date'] as String?,
  );
}

class Notes {
  final String book;
  final int chapter;
  final int verse;
  final String text;
  final String date;

  Notes({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    String? date,
  }) : date = date ?? _formatDate(DateTime.now());

  Map<String, dynamic> toJson() => {
    'book': book,
    'chapter': chapter,
    'verse': verse,
    'text': text,
    'date': date,
  };

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    book: json['book'] as String,
    chapter: json['chapter'] as int,
    verse: json['verse'] as int,
    text: json['text'] as String,
    date: json['date'] as String?,
  );
}

class Highlight {
  final String book;
  final int chapter;
  final int verse;
  final String value;
  final int color;
  final String date;

  Highlight({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.value,
    this.color = 0xFFF4B400,
    String? date,
  }) : date = date ?? _formatDate(DateTime.now());

  Map<String, dynamic> toJson() => {
    'book': book,
    'chapter': chapter,
    'verse': verse,
    'value': value,
    'color': color,
    'date': date,
  };

  factory Highlight.fromJson(Map<String, dynamic> json) => Highlight(
    book: json['book'] as String,
    chapter: json['chapter'] as int,
    verse: json['verse'] as int,
    value: json['value'] as String,
    color: json['color'] as int? ?? 0xFFF4B400,
    date: json['date'] as String?,
  );
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
