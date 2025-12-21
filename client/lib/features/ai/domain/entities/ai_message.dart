enum AiRole { user, assistant }

class AiMessage {
  final String id;
  final String text;
  final AiRole role;
  final DateTime createdAt;

  const AiMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
  });
}
