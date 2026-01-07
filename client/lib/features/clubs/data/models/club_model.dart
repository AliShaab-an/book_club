import 'package:client/features/clubs/domain/entities/club.dart';

class ClubModel extends Club {
  const ClubModel({
    required super.id,
    required super.name,
    super.bookId,
    super.bookTitle,
    super.bookCoverUrl,
    super.genre,
    super.membersCount,
    super.unreadCount,
    required super.createdAt,
  });

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? 'Unnamed Club',
      bookId: map['book_id']?.toString(),
      bookTitle: map['book_title'],
      bookCoverUrl: map['book_cover_url'],
      genre: map['genre'] ?? 'General',
      membersCount: map['members_count'] ?? 1,
      unreadCount: map['unread_count'] ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, if (bookId != null) 'book_id': bookId};
  }
}
