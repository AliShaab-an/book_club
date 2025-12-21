import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 360 ? 120.0 : 140.0;
    final imageHeight = screenWidth < 360 ? 150.0 : 180.0;
    final titleFontSize = screenWidth < 360 ? 13.0 : 14.0;
    final authorFontSize = screenWidth < 360 ? 11.0 : 12.0;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        color: Pallete.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Book Cover
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

              // Book Info
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
