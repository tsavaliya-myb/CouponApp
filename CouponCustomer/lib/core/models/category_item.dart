// lib/core/models/category_item.dart

class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String? subtitle;
  final String? imageUrl;
  final bool isActive;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    this.subtitle,
    this.imageUrl,
    this.isActive = true,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        subtitle: json['subtitle'] as String?,
        imageUrl: json['imageUrl'] as String?,
        isActive: json['isActive'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
        'isActive': isActive,
      };

  @override
  bool operator ==(Object other) => other is CategoryItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CategoryItem(id: $id, name: $name, slug: $slug)';
}
