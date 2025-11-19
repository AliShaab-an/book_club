class Group {
  final String id;
  final String name;
  final String? description;
  final String userId;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.createdAt,
  });
}
