class ParentCategory {
  final String id;
  final String name;

  ParentCategory({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ParentCategory.fromJson(Map<String, dynamic> json) {
    return ParentCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final int displayOrder;
  final String parentCategoryId;
  final String? iconUrl;
  final int wordsCount;
  final ParentCategory? parentCategory;

  SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.displayOrder,
    required this.parentCategoryId,
    this.iconUrl,
    required this.wordsCount,
    this.parentCategory,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'displayOrder': displayOrder,
      'parentCategoryId': parentCategoryId,
      'iconUrl': iconUrl,
      'wordsCount': wordsCount,
      'parentCategory': parentCategory?.toJson(),
    };
  }

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      displayOrder: json['displayOrder'],
      parentCategoryId: json['parentCategoryId'],
      iconUrl: json['iconUrl'],
      wordsCount: json['wordsCount'],
      parentCategory: json['parentCategory'] != null
          ? ParentCategory.fromJson(json['parentCategory'])
          : null,
    );
  }

  SubCategory copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    int? displayOrder,
    String? parentCategoryId,
    String? iconUrl,
    int? wordsCount,
    ParentCategory? parentCategory,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      iconUrl: iconUrl ?? this.iconUrl,
      wordsCount: wordsCount ?? this.wordsCount,
      parentCategory: parentCategory ?? this.parentCategory,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, slug: $slug, description: $description, displayOrder: $displayOrder, parentCategoryId: $parentCategoryId, iconUrl: $iconUrl, wordsCount: $wordsCount, parentCategory: $parentCategory)';
  }
}