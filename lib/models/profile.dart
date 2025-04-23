class Profile {
  final String name;
  final String email;
  final String? avatarUrl;
  final String language;

  Profile({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.language,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? 'User Profile',
      email: json['email'] ?? 'user@example.com',
      avatarUrl: json['avatarUrl'],
      language: json['language'] ?? 'English',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'language': language,
    };
  }

  Profile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? language,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      language: language ?? this.language,
    );
  }
}
