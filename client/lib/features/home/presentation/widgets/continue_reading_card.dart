import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class ContinueReadingCard extends StatelessWidget {
  final Book? book;
  final VoidCallback? onTap;

  const ContinueReadingCard({super.key, this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      color: Pallete.greenColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  image: book!.coverImage != null
                      ? DecorationImage(
                          image: NetworkImage(book!.coverImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: book!.coverImage == null
                    ? const Icon(
                        Icons.book,
                        size: 32,
                        color: Pallete.subtitleText,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continue Reading',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book!.title,
                      style: const TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (book!.author != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'by ${book!.author}',
                        style: const TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Pallete.whiteColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
