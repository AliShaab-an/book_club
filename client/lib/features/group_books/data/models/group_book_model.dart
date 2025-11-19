import 'package:client/features/group_books/domain/entities/group_book.dart';

class GroupBookModel extends GroupBook {
  const GroupBookModel({
    required super.id,
    required super.groupId,
    required super.bookId,
    required super.selectedDate,
    required super.status,
  });

  factory GroupBookModel.fromMap(Map<String, dynamic> map) {
    return GroupBookModel(
      id: map['id']?.toString() ?? '',
      groupId: map['group_id']?.toString() ?? '',
      bookId: map['book_id']?.toString() ?? '',
      selectedDate: DateTime.parse(map['selected_date']),
      status: map['status'] ?? 'not_started',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'book_id': bookId,
      'status': status,
    };
  }
}
