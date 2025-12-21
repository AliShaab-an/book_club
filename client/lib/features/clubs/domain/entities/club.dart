class Club {
  final String id;
  final String name;
  final String bookId;
  final String bookTitle;
  final String bookCoverUrl;
  final String genre;
  final int membersCount;
  final int unreadCount;
  final DateTime createdAt;

  const Club({
    required this.id,
    required this.name,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.genre,
    required this.membersCount,
    this.unreadCount = 0,
    required this.createdAt,
  });
}
