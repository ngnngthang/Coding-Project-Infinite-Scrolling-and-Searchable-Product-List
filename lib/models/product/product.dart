import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.thumbnail,
  });
  final int id;
  final String title;
  final String description;
  final num price;
  final String? thumbnail;

  factory Product.from(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, thumbnail: $thumbnail}';
  }

  static List<Product> dummy() {
    return List.generate(
      10,
      (index) => Product(
        id: index,
        title: 'Product $index',
        description: '',
        price: 0,
      ),
    );
  }
}
