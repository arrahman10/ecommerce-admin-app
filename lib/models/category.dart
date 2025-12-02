const String collectionCategory = 'Categories';
const String categoryFieldId = 'id';
const String categoryFieldName = 'name';
const String categoryFieldProductCount = 'productCount';

class Category {
  final String? id;
  final String name;
  final int productCount;

  const Category({this.id, required this.name, this.productCount = 0});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      categoryFieldId: id,
      categoryFieldName: name,
      categoryFieldProductCount: productCount,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map[categoryFieldId] as String?,
      name: (map[categoryFieldName] ?? '') as String,
      productCount: (map[categoryFieldProductCount] ?? 0) as int,
    );
  }

  Category copyWith({String? id, String? name, int? productCount}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      productCount: productCount ?? this.productCount,
    );
  }
}
