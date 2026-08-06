class DevotionalList {
  final List<Devotion> devotionals;

  DevotionalList({required this.devotionals});

  factory DevotionalList.fromJson(Map<String, dynamic> json) {
    var data = json['devotionals'] as List<dynamic>;
    List<Devotion> devotions = data.map((e) => Devotion.fromJson(e)).toList();
    return DevotionalList(devotionals: devotions);
  }
}

class Devotion {
  final Verse verse;
  final Devotional devotional;

  Devotion({required this.verse, required this.devotional});

  factory Devotion.fromJson(Map<String, dynamic> json) => Devotion(
    verse: Verse.fromJson(json['verse']),
    devotional: Devotional.fromJson(json['devotional']),
  );
}

class Verse {
  final String ref;
  final String text;

  Verse({required this.ref, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) =>
      Verse(ref: json['reference'], text: json['text']);
}

class Devotional {
  final String title;
  final String body;
  final String reflection;
  final String prayer;

  Devotional({
    required this.title,
    required this.body,
    required this.reflection,
    required this.prayer,
  });

  factory Devotional.fromJson(Map<String, dynamic> json) => Devotional(
    title: json['title'],
    body: json['body'],
    reflection: json['reflection'],
    prayer: json['prayer'],
  );
}
