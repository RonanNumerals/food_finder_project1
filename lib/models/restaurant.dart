import 'dart:convert';
import 'package:food_finder_project1/models/menu.dart';

// The Restaurant model represents a dining establishment, including its name, image, menu items, description, hours, location, rating, price level, cuisine type, mood tags, and a pre-computed embedding vector for vibe-based recommendations.
class Restaurant {
  final int? id;
  final String name;
  final String imagePath;
  final List<MenuItem> menuItems;
  final String description;
  final String hours;
  final String location;
  final double rating;
  final int priceLevel; // 1 = $, 2 = $$, 3 = $$$
  final String? cuisine;
  // Mood/vibe tags used for semantic matching (e.g. ['chill', 'cozy', 'study spot'])
  final List<String> tags;
  // Pre-computed embedding vector for mood-based similarity search; null until computed
  final List<double>? vibeEmbedding;

  // Constructor for Restaurant, with optional id for database use.
  Restaurant({
    this.id,
    required this.name,
    required this.imagePath,
    required this.menuItems,
    required this.description,
    required this.hours,
    required this.location,
    required this.rating,
    required this.priceLevel,
    this.cuisine,
    this.tags = const [],
    this.vibeEmbedding,
  });

  String get priceLabelString => '\$' * priceLevel;

  // Converts the Restaurant instance into a Map for database storage, encoding lists as JSON strings.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'image_path': imagePath,
      'description': description,
      'location': location,
      'rating': rating,
      'hours': hours,
      'price_level': priceLevel,
      'cuisine': cuisine,
      'tags': jsonEncode(tags),
      'vibe_embedding': vibeEmbedding != null
          ? jsonEncode(vibeEmbedding)
          : null,
    };
  }

  // Factory constructor to create a Restaurant instance from a Map, decoding lists from JSON strings.
  factory Restaurant.fromMap(
    Map<String, dynamic> map, {
    List<MenuItem> menuItems = const [],
  }) {
    // Decode tags from JSON-encoded string
    List<String> parsedTags = const [];
    final rawTags = map['tags'];
    if (rawTags is String && rawTags.isNotEmpty) {
      parsedTags = (jsonDecode(rawTags) as List).cast<String>();
    }

    // Decode vibe embedding from JSON-encoded string
    List<double>? parsedEmbedding;
    final rawEmbedding = map['vibe_embedding'];
    if (rawEmbedding is String && rawEmbedding.isNotEmpty) {
      parsedEmbedding = (jsonDecode(rawEmbedding) as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    // Return a new Restaurant instance with the parsed values from the map.
    return Restaurant(
      id: map['id'] as int?,
      name: map['name'] as String,
      imagePath: map['image_path'] as String? ?? '',
      menuItems: menuItems,
      description: map['description'] as String? ?? '',
      hours: map['hours'] as String? ?? '',
      location: map['location'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      priceLevel: map['price_level'] as int? ?? 1,
      cuisine: map['cuisine'] as String?,
      tags: parsedTags,
      vibeEmbedding: parsedEmbedding,
    );
  }
}