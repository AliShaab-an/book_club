class Book {
  final String id;
  final String title;
  final String? author;
  final String? description;
  final String? coverImage;
  final int? pages;
  final String? source;
  final String? externalId;

  const Book({
    required this.id,
    required this.title,
    this.author,
    this.description,
    this.coverImage,
    this.pages,
    this.source,
    this.externalId,
  });
}
