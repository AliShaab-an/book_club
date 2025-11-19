import 'package:client/features/groups/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    super.description,
    required super.userId,
    required super.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      userId: map['user_id']?.toString() ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description, 'user_id': userId};
  }
}
