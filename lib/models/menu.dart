import 'dart:convert';

class MenuItem {
  final int? id;
  final int? restaurantId;
  final String name;
  final String description;
  final List<double> price;

  MenuItem({
    this.id,
    this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (restaurantId != null) 'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': jsonEncode(price),
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    List<double> parsedPrice = [];
    final rawPrice = map['price'];
    if (rawPrice is String && rawPrice.isNotEmpty) {
      parsedPrice = (jsonDecode(rawPrice) as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    return MenuItem(
      id: map['id'] as int?,
      restaurantId: map['restaurant_id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      price: parsedPrice,
    );
  }
}
