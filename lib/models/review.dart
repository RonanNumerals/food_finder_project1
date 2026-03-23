class Review {
  final int? id;
  final int restaurantId;
  final String writtenReview;
  final double rating;
  final String name;
  final String createdAt;

  /// Populated by join queries only — not stored in the DB.
  final String? restaurantName;

  Review({
    this.id,
    required this.restaurantId,
    required this.writtenReview,
    required this.rating,
    required this.name,
    required this.createdAt,
    this.restaurantName,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'restaurant_id': restaurantId,
      'written_review': writtenReview,
      'rating': rating,
      'name': name,
      'created_at': createdAt,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as int?,
      restaurantId: map['restaurant_id'] as int,
      writtenReview: map['written_review'] as String,
      rating: (map['rating'] as num).toDouble(),
      name: map['name'] as String,
      createdAt: map['created_at'] as String,
      restaurantName: map['restaurant_name'] as String?,
    );
  }
}
