class Favorite {
  final int? id;
  final int restaurantId;
  final String createdAt;

  Favorite({this.id, required this.restaurantId, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'restaurant_id': restaurantId,
      'created_at': createdAt,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as int?,
      restaurantId: map['restaurant_id'] as int,
      createdAt: map['created_at'] as String,
    );
  }
}
