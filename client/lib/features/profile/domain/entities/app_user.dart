class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> favoriteGenres;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.favoriteGenres = const [],
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    List<String>? favoriteGenres,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
    );
  }
}
