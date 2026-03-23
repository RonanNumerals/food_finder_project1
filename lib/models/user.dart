// The User model represents a user of the app, including their name, profile image, and location.
class User {
  final int? id;
  final String name;
  final String? profileImage;
  final String? location;

  // Constructor for User.
  User({this.id, required this.name, this.profileImage, this.location});

  // Converts the User instance into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'profile_image': profileImage,
      'location': location,
    };
  }

  // Factory constructor to create a User instance from a Map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      profileImage: map['profile_image'] as String?,
      location: map['location'] as String?,
    );
  }

  // Creates a copy of the User instance with optional new values for each field.
  User copyWith({
    int? id,
    String? name,
    String? profileImage,
    String? location,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
    );
  }
}
