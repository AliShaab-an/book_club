import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/club.dart';

class DiscoverClubCard extends StatelessWidget {
  final Club club;
  final VoidCallback onJoin;

  const DiscoverClubCard({super.key, required this.club, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Pallete.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Book Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: club.bookCoverUrl != null
                  ? Image.network(
                      club.bookCoverUrl!,
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Pallete.borderColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.book,
                            color: Pallete.greyColor,
                            size: 30,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 60,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Pallete.borderColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.book,
                        color: Pallete.greyColor,
                        size: 30,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Club Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Pallete.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club.bookTitle ?? 'No book selected',
                    style: TextStyle(
                      fontSize: 14,
                      color: club.bookTitle != null
                          ? Pallete.greyColor
                          : Pallete.greyColor.withOpacity(0.6),
                      fontStyle: club.bookTitle != null
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 16,
                        color: Pallete.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${club.membersCount} members',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Pallete.greyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Join Button
            ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.greenColor,
                foregroundColor: Pallete.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
