import 'lesson.dart';

class Category {
  final String id;
  final String title;
  final String shortDescription;
  final String imageUrl;
  final List<Lesson> lessons;

  Category({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.imageUrl,
    required this.lessons,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'imageUrl': imageUrl,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      shortDescription: json['shortDescription'],
      imageUrl: json['imageUrl'],
      lessons: (json['lessons'] as List)
          .map((lessonJson) => Lesson.fromJson(lessonJson))
          .toList(),
    );
  }

  Category copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? imageUrl,
    List<Lesson>? lessons,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      imageUrl: imageUrl ?? this.imageUrl,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, title: $title, shortDescription: $shortDescription, imageUrl: $imageUrl, lessons: ${lessons.length} lessons)';
  }
}