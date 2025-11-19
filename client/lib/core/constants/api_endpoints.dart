class ApiEndpoints {
  // Auth endpoints
  static const String register = '/auth/';
  static const String login = '/auth/token';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';

  // Users endpoints
  static const String users = '/users';
  static const String userById = '/users/{id}';

  // Groups endpoints
  static const String groups = '/groups';
  static const String groupById = '/groups/{id}';
  static const String joinGroup = '/groups/{id}/join';
  static const String leaveGroup = '/groups/{id}/leave';

  // Books endpoints
  static const String books = '/books';
  static const String bookById = '/books/{id}';
  static const String searchBooks = '/books/search';

  // Group Books endpoints
  static const String groupBooks = '/group-books';
  static const String groupBooksByGroup = '/group-books/group/{groupId}';

  // Chat endpoints
  static const String chats = '/chats';
  static const String chatsByGroup = '/chats/group/{groupId}';
  static const String sendMessage = '/chats/{groupId}/message';
}
