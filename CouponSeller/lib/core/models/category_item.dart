class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String? iconName;
  final bool isActive;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    this.iconName,
    this.isActive = true,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      iconName: json['iconName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) => other is CategoryItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
