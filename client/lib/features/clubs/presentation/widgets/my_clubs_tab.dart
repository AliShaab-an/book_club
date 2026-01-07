import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/club.dart';
import '../providers/clubs_providers.dart';
import 'my_club_card.dart';
import 'empty_state.dart';

class MyClubsTab extends ConsumerWidget {
  const MyClubsTab({super.key});

  void _navigateToClubDetails(BuildContext context, String clubId) {
    // TODO: Navigate to ClubDetailsPage or ClubDiscussionPage
    // Navigator.pushNamed(context, '/clubs/$clubId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(myClubsProvider);

    return clubsAsync.when(
      data: (clubs) {
        if (clubs.isEmpty) {
          return const EmptyState(
            icon: Icons.groups_outlined,
            title: 'No Clubs Yet',
            message:
                'Create or join a club to start reading and discussing with others!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myClubsProvider);
          },
          color: Pallete.greenColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              final club = clubs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MyClubCard(
                  club: club,
                  onTap: () => _navigateToClubDetails(context, club.id),
                ),
              );
            },
          ),
        );
      },
      loading: () =>  Center(
        child: CircularProgressIndicator(color: Pallete.greenColor),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Pallete.errorColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load clubs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Pallete.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(fontSize: 14, color: Pallete.greyColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(myClubsProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.greenColor,
                foregroundColor: Pallete.whiteColor,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
