import 'package:client/features/books/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    super.author,
    super.description,
    super.coverImage,
    super.pages,
    super.source,
    super.externalId,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      author: map['author'],
      description: map['description'],
      coverImage: map['cover_image'],
      pages: map['pages'] ?? map['page_count'],
      source: map['source'],
      externalId: map['external_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'cover_image': coverImage,
      'pages': pages,
      'source': source,
      'external_id': externalId,
    };
  }
}
