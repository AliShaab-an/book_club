import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';
import '../providers/clubs_providers.dart';
import 'discover_club_card.dart';

class PopularClubsSection extends ConsumerWidget {
  const PopularClubsSection({super.key});

  void _joinClub(WidgetRef ref, String clubId) {
    // TODO: Implement join club functionality
    ref.read(joinClubProvider(clubId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverClubs = ref.watch(discoverClubsProvider);

    return discoverClubs.when(
      data: (clubs) {
        if (clubs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No clubs available yet',
                style: TextStyle(fontSize: 16, color: Pallete.greyColor),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Discover Clubs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Pallete.blackColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  final club = clubs[index];
                  return Container(
                    width: 320,
                    margin: const EdgeInsets.only(right: 12),
                    child: DiscoverClubCard(
                      club: club,
                      onJoin: () => _joinClub(ref, club.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error loading clubs: $error',
          style: const TextStyle(color: Pallete.errorColor),
        ),
      ),
    );
  }
}
