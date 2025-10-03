enum Language {
  english(0, 'English'),
  russian(1, 'Russian'),
  romanian(2, 'Romanian'),
  ukrainian(3, 'Ukrainian'),
  polish(4, 'Polish'),
  french(5, 'French'),
  mandarin(6, 'Mandarin'),
  uzbek(7, 'Uzbek'),
  tajik(8, 'Tajik'),
  punjabi(9, 'Punjabi'),
  german(10, 'German'),
  hindi(11, 'Hindi'),
  indonesian(12, 'Indonesian'),
  portuguese(13, 'Portuguese'),
  japanese(14, 'Japanese'),
  turkish(15, 'Turkish'),
  spanish(16, 'Spanish');

  final int value;
  final String displayName;

  const Language(this.value, this.displayName);

  static Language fromValue(int value) {
    return Language.values.firstWhere(
      (lang) => lang.value == value,
      orElse: () => Language.english,
    );
  }

  static Language? tryFromValue(int? value) {
    if (value == null) return null;
    try {
      return Language.values.firstWhere((lang) => lang.value == value);
    } catch (e) {
      return null;
    }
  }
}

class WordCategory {
  final String id;
  final String name;
  final String slug;
  final String? iconUrl;

  WordCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.iconUrl,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      id: json['id'] ?? json['Id'],
      name: json['name'] ?? json['Name'],
      slug: json['slug'] ?? json['Slug'],
      iconUrl: json['iconUrl'] ?? json['IconUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Slug': slug,
      'IconUrl': iconUrl,
    };
  }
}

class Translation {
  final Language language;
  final String translatedText;
  final String? definition;
  final String? pronunciation;
  final String? usageExample;
  final String? notes;

  Translation({
    required this.language,
    required this.translatedText,
    this.definition,
    this.pronunciation,
    this.usageExample,
    this.notes,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    final languageValue = json['language'] ?? json['Language'] ?? 0;
    return Translation(
      language: Language.fromValue(languageValue is int ? languageValue : 0),
      translatedText: json['translatedText'] ?? json['TranslatedText'],
      definition: json['definition'] ?? json['Definition'],
      pronunciation: json['pronunciation'] ?? json['Pronunciation'],
      usageExample: json['usageExample'] ?? json['UsageExample'],
      notes: json['notes'] ?? json['Notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Language': language.value,
      'TranslatedText': translatedText,
      'Definition': definition,
      'Pronunciation': pronunciation,
      'UsageExample': usageExample,
      'Notes': notes,
    };
  }
}

class Word {
  final String id;
  final String term;
  final String? partOfSpeech;
  final int difficulty;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WordCategory category;
  final List<Translation> translations;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;

  Word({
    required this.id,
    required this.term,
    this.partOfSpeech,
    required this.difficulty,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.translations,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Term': term,
      'PartOfSpeech': partOfSpeech,
      'Difficulty': difficulty,
      'CategoryId': categoryId,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'Category': category.toJson(),
      'Translations': translations.map((t) => t.toJson()).toList(),
      'ImageUrl': imageUrl,
      'AudioUrl': audioUrl,
      'VideoUrl': videoUrl,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    // Handle both lowercase and capitalized field names
    final id = json['id'] ?? json['Id'];
    final term = json['term'] ?? json['Term'];
    final partOfSpeech = json['partOfSpeech'] ?? json['PartOfSpeech'];
    final difficulty = json['difficulty'] ?? json['Difficulty'];
    final categoryId = json['categoryId'] ?? json['CategoryId'];
    final createdAtStr = json['createdAt'] ?? json['CreatedAt'];
    final updatedAtStr = json['updatedAt'] ?? json['UpdatedAt'];
    final categoryJson = json['category'] ?? json['Category'];
    final imageUrl = json['imageUrl'] ?? json['ImageUrl'];
    final audioUrl = json['audioUrl'] ?? json['AudioUrl'];
    final videoUrl = json['videoUrl'] ?? json['VideoUrl'];

    // Handle translation (singular) or translations (plural)
    List<Translation> translations = [];
    if (json['translation'] != null) {
      // Single translation object
      translations = [Translation.fromJson(json['translation'])];
    } else if (json['Translations'] != null) {
      // Multiple translations array
      translations = (json['Translations'] as List)
          .map((t) => Translation.fromJson(t))
          .toList();
    }

    return Word(
      id: id,
      term: term,
      partOfSpeech: partOfSpeech,
      difficulty: difficulty,
      categoryId: categoryId,
      createdAt: DateTime.parse(createdAtStr),
      updatedAt: updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.parse(createdAtStr),
      category: WordCategory.fromJson(categoryJson),
      translations: translations,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      videoUrl: videoUrl,
    );
  }

  Word copyWith({
    String? id,
    String? term,
    String? partOfSpeech,
    int? difficulty,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    WordCategory? category,
    List<Translation>? translations,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
  }) {
    return Word(
      id: id ?? this.id,
      term: term ?? this.term,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      difficulty: difficulty ?? this.difficulty,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      translations: translations ?? this.translations,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Word(id: $id, term: $term, partOfSpeech: $partOfSpeech, difficulty: $difficulty, categoryId: $categoryId, category: ${category.name}, translations: ${translations.length}, imageUrl: $imageUrl, audioUrl: $audioUrl, videoUrl: $videoUrl)';
  }
}