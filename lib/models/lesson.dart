import 'word.dart';

class Lesson {
  final String id;
  final String title;
  final List<Word> words;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.words,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'words': words.map((word) => word.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      words: (json['words'] as List)
          .map((wordJson) => Word.fromJson(wordJson))
          .toList(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Lesson copyWith({
    String? id,
    String? title,
    List<Word>? words,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      words: words ?? this.words,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, words: $words)';
  }
}