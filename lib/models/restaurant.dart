import 'package:food_finder_project1/models/menu.dart';

class Restaurant {
  final String name;
  final String imagePath;
  final List<MenuItem> menuItems;
  final String description;
  final List<String> hours;
  final String location;
  final double rating;
  final int priceLevel; // 1 = $, 2 = $$, 3 = $$$

  Restaurant({
    required this.name,
    required this.imagePath,
    required this.menuItems,
    required this.description,
    required this.hours,
    required this.location,
    required this.rating,
    required this.priceLevel,
  });

  String get priceLabelString => '\$' * priceLevel;
}
