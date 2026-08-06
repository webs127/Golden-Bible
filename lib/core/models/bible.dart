class Bible {
  final List<Book> books;

  Bible({required this.books});

  factory Bible.fromJson(List json) {
    List<Book> bk = json.map((e) => Book.fromJson(e)).toList();
    return Bible(books: bk);
  }
}

class Book {
  final String abbrev;
  final String name;
  final List<Chapters> chapters;

  Book({required this.abbrev, required this.name, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      abbrev: json['abbrev'] as String,
      name: (json['name'] as String?) ?? json['abbrev'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((chapterJson) => Chapters.fromJson(chapterJson as List<dynamic>))
          .toList(),
    );
  }
}

class Chapters {
  final List<String> verses;

  Chapters({required this.verses});

  factory Chapters.fromJson(List<dynamic> json) {
    return Chapters(
      verses: json.map((verse) => verse.toString()).toList(),
    );
  }
}


class CurrentBook {
  final String name;
  final int chapter;
  final List<String> verses;

  CurrentBook({required this.name, required this.chapter, required this.verses});
}
