import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';

class TrendingBooksSection extends StatelessWidget {
  final List<Book> books;
  final Function(String bookId)? onBookTap;

  const TrendingBooksSection({super.key, required this.books, this.onBookTap});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final listHeight = screenWidth < 360 ? 240.0 : 270.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Trending Now',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: listHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onTap: () => onBookTap?.call(book.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
