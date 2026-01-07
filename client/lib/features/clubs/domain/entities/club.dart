class Club {
  final String id;
  final String name;
  final String? bookId;
  final String? bookTitle;
  final String? bookCoverUrl;
  final String genre;
  final int membersCount;
  final int unreadCount;
  final DateTime createdAt;

  const Club({
    required this.id,
    required this.name,
    this.bookId,
    this.bookTitle,
    this.bookCoverUrl,
    this.genre = 'General',
    this.membersCount = 1,
    this.unreadCount = 0,
    required this.createdAt,
  });
}
