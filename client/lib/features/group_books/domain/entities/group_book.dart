class GroupBook {
  final String id;
  final String groupId;
  final String bookId;
  final DateTime selectedDate;
  final String status; // not_started, reading, finished

  const GroupBook({
    required this.id,
    required this.groupId,
    required this.bookId,
    required this.selectedDate,
    required this.status,
  });
}
