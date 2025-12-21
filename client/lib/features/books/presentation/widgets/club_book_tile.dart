import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class ClubBookTile extends StatelessWidget {
  final Book book;
  final int clubCount;
  final bool isMyClub;
  final VoidCallback? onViewClub;
  final VoidCallback? onJoinClub;

  const ClubBookTile({
    super.key,
    required this.book,
    required this.clubCount,
    this.isMyClub = false,
    this.onViewClub,
    this.onJoinClub,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      color: Pallete.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Book Cover
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
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
                      size: 32,
                      color: Pallete.subtitleText,
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            // Book Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: Pallete.subtitleText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),

                  // Club Info
                  Row(
                    children: [
                      Icon(Icons.group, size: 16, color: Pallete.greenColor),
                      const SizedBox(width: 4),
                      Text(
                        isMyClub
                            ? 'My Club'
                            : '$clubCount ${clubCount == 1 ? 'club' : 'clubs'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Pallete.greenColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Action Button
            ElevatedButton(
              onPressed: isMyClub ? onViewClub : onJoinClub,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.greenColor,
                foregroundColor: Pallete.whiteColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isMyClub ? 'View' : 'Join',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
