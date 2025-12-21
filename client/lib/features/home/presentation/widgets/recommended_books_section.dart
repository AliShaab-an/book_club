import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class RecommendedBooksSection extends StatelessWidget {
  final List<Book> books;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onBookTap;

  const RecommendedBooksSection({
    super.key,
    required this.books,
    this.isLoading = false,
    this.hasError = false,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'My Books',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Pallete.greenColor),
            ),
          )
        else if (hasError)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load books',
                style: TextStyle(color: Pallete.errorColor, fontSize: 14),
              ),
            ),
          )
        else if (books.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No books available',
                style: TextStyle(color: Pallete.subtitleText, fontSize: 14),
              ),
            ),
          )
        else
          Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final listHeight = screenWidth < 360 ? 200.0 : 230.0;
              return SizedBox(
                height: listHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return _BookCard(book: book, onTap: onBookTap);
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const _BookCard({required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 360 ? 120.0 : 140.0;
    final imageHeight = screenWidth < 360 ? 120.0 : 140.0;
    final titleFontSize = screenWidth < 360 ? 13.0 : 14.0;
    final authorFontSize = screenWidth < 360 ? 11.0 : 12.0;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        color: Pallete.whiteColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: book.coverImage != null
                      ? DecorationImage(
                          image: NetworkImage(book.coverImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: book.coverImage == null
                    ? const Icon(
                        Icons.book,
                        size: 48,
                        color: Pallete.subtitleText,
                      )
                    : null,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Pallete.blackColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (book.author != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          book.author!,
                          style: TextStyle(
                            fontSize: authorFontSize,
                            color: Pallete.subtitleText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
