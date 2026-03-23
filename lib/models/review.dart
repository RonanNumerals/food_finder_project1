// The Review model represents a user's review of a restaurant, including the review text, rating, reviewer's name, and timestamp.
class Review {
  final int? id;
  final int restaurantId;
  final String writtenReview;
  final double rating;
  final String name;
  final String createdAt;

  /// Populated by join queries only — not stored in the DB.
  final String? restaurantName;

  // Constructor for Review.
  Review({
    this.id,
    required this.restaurantId,
    required this.writtenReview,
    required this.rating,
    required this.name,
    required this.createdAt,
    this.restaurantName,
  });

  // Converts the Review instance into a Map for database storage.
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

  // Factory constructor to create a Review instance from a Map.
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
