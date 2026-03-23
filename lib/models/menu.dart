import 'dart:convert';

// The MenuItem model represents an individual menu item offered by a restaurant, including its name, description, and price. 
class MenuItem {
  final int? id;
  final int? restaurantId;
  final String name;
  final String description;
  final List<double> price;

  // Constructor for MenuItem, with optional id and restaurantId for database use.
  MenuItem({
    this.id,
    this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
  });

  // Converts the MenuItem instance into a Map for database storage, encoding the price list as a JSON string.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (restaurantId != null) 'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': jsonEncode(price),
    };
  }

  // Factory constructor to create a MenuItem instance from a Map, decoding the price from a JSON string.
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    List<double> parsedPrice = [];
    final rawPrice = map['price'];
    if (rawPrice is String && rawPrice.isNotEmpty) {
      parsedPrice = (jsonDecode(rawPrice) as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    // Return a new MenuItem instance with the parsed values from the map.
    return MenuItem(
      id: map['id'] as int?,
      restaurantId: map['restaurant_id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      price: parsedPrice,
    );
  }
}
