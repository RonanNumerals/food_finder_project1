// The Favorite model represents a user's favorite restaurant, including a reference to the restaurant and a timestamp of when it was favorited.
class Favorite {
  final int? id;
  final int restaurantId;
  final String createdAt;

  // Constructor for Favorite, with optional id for database use.
  Favorite({this.id, required this.restaurantId, required this.createdAt});

  // Converts the Favorite instance into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'restaurant_id': restaurantId,
      'created_at': createdAt,
    };
  }

  // Factory constructor to create a Favorite instance from a Map.
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as int?,
      restaurantId: map['restaurant_id'] as int,
      createdAt: map['created_at'] as String,
    );
  }
}
