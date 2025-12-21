import 'package:client/features/profile/domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.favoriteGenres,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      name: '${map['first_name'] ?? ''} ${map['last_name'] ?? ''}'.trim(),
      email: map['email'] ?? '',
      avatarUrl: map['avatar_url'],
      favoriteGenres: map['favorite_genres'] != null
          ? List<String>.from(map['favorite_genres'] as List)
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar_url': avatarUrl,
      'favorite_genres': favoriteGenres,
    };
  }
}
