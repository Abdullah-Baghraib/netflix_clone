class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final List<int> favoriteMovies;
  final bool isEmailVerified;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.favoriteMovies = const [],
    this.isEmailVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      displayName: json['display_name'],
      photoUrl: json['photo_url'],
      favoriteMovies: List<int>.from(json['favorite_movies'] ?? []),
      isEmailVerified: json['is_email_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'favorite_movies': favoriteMovies,
      'is_email_verified': isEmailVerified,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    List<int>? favoriteMovies,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
