const String collectionBrand = 'Brands';
const String brandFieldId = 'id';
const String brandFieldName = 'name';

class Brand {
  final String? id;
  final String name;

  const Brand({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{brandFieldId: id, brandFieldName: name};
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map[brandFieldId] as String?,
      name: (map[brandFieldName] ?? '') as String,
    );
  }

  Brand copyWith({String? id, String? name}) {
    return Brand(id: id ?? this.id, name: name ?? this.name);
  }
}
