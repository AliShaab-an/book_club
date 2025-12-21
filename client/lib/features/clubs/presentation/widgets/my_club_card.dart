import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/club.dart';

class MyClubCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const MyClubCard({super.key, required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                child: Image.network(
                  club.bookCoverUrl,
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
                ),
              ),
              const SizedBox(width: 12),
              // Club Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            club.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Pallete.blackColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (club.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Pallete.greenColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${club.unreadCount} new',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Pallete.whiteColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club.bookTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Pallete.greyColor,
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
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.label_outline,
                          size: 16,
                          color: Pallete.greyColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            club.genre,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Pallete.greyColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
