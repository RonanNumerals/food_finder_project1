class User {
  final int? id;
  final String name;
  final String? profileImage;
  final String? location;

  User({this.id, required this.name, this.profileImage, this.location});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'profile_image': profileImage,
      'location': location,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      profileImage: map['profile_image'] as String?,
      location: map['location'] as String?,
    );
  }

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
