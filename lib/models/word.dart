class Word {
  final String text;
  final String imageUrl;
  final String? explanation;
  final String? audioUrl;

  Word({
    required this.text,
    required this.imageUrl,
    this.explanation,
    this.audioUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'explanation': explanation,
      'audioUrl': audioUrl,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text'],
      imageUrl: json['imageUrl'],
      explanation: json['explanation'],
      audioUrl: json['audioUrl'],
    );
  }

  Word copyWith({
    String? text,
    String? imageUrl,
    String? explanation,
    String? audioUrl,
  }) {
    return Word(
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      explanation: explanation ?? this.explanation,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word && other.text == text;
  }

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() {
    return 'Word(text: $text, imageUrl: $imageUrl, explanation: $explanation, audioUrl: $audioUrl)';
  }
}