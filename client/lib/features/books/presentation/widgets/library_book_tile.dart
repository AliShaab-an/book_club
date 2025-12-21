import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class LibraryBookTile extends StatelessWidget {
  final Book book;
  final String status;
  final double? progress;
  final VoidCallback? onTap;
  final Function(String action)? onActionSelected;

  const LibraryBookTile({
    super.key,
    required this.book,
    required this.status,
    this.progress,
    this.onTap,
    this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      color: Pallete.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),

                    // Progress Indicator for Reading status
                    if (status == 'Reading' && progress != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Pallete.greenColor,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress! * 100).toInt()}% complete',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Pallete.subtitleText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Actions Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Pallete.blackColor),
                onSelected: onActionSelected,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'move', child: Text('Move to...')),
                  const PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Want to Read':
        return Colors.blue;
      case 'Reading':
        return Pallete.greenColor;
      case 'Finished':
        return Colors.orange;
      default:
        return Pallete.subtitleText;
    }
  }
}
