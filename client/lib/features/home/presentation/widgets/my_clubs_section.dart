import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/groups/domain/entities/group.dart';
import 'package:flutter/material.dart';

class MyClubsSection extends StatelessWidget {
  final List<Group> clubs;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onClubTap;

  const MyClubsSection({
    super.key,
    required this.clubs,
    this.isLoading = false,
    this.hasError = false,
    this.onClubTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'My Book Clubs',
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
                'Failed to load clubs',
                style: TextStyle(color: Pallete.errorColor, fontSize: 14),
              ),
            ),
          )
        else if (clubs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No clubs joined yet',
                style: TextStyle(color: Pallete.subtitleText, fontSize: 14),
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                final club = clubs[index];
                return _ClubCard(club: club, onTap: onClubTap);
              },
            ),
          ),
      ],
    );
  }
}

class _ClubCard extends StatelessWidget {
  final Group club;
  final VoidCallback? onTap;

  const _ClubCard({required this.club, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        color: Pallete.whiteColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Pallete.greenColor,
                      radius: 20,
                      child: const Icon(
                        Icons.group,
                        color: Pallete.whiteColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        club.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Pallete.blackColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (club.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    club.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Pallete.subtitleText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
