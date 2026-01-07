import 'package:client/features/books/presentation/widgets/club_book_tile.dart';
import 'package:client/features/clubs/presentation/providers/clubs_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';

class ClubsTab extends ConsumerWidget {
  const ClubsTab({super.key});

  void _navigateToClubDetails(BuildContext context, String clubId) {
    // TODO: Navigate to ClubDetailsPage
    print('Navigate to club details: $clubId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(myClubsProvider);

    return clubsAsync.when(
      data: (clubs) {
        // Filter clubs that have books
        final clubsWithBooks = clubs
            .where((club) => club.bookId != null)
            .toList();

        if (clubsWithBooks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups_outlined, size: 64, color: Pallete.greyColor),
                SizedBox(height: 16),
                Text(
                  'No club books yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Pallete.greyColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join a club and select a book to see it here',
                  style: TextStyle(fontSize: 14, color: Pallete.greyColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: clubsWithBooks.length,
          itemBuilder: (context, index) {
            final club = clubsWithBooks[index];

            // Create a Book object from club data
            final book = Book(
              id: club.bookId!,
              title: club.bookTitle ?? 'Unknown Book',
              author: 'Unknown Author', // TODO: Add author to club data
              coverImage: club.bookCoverUrl,
            );

            return ClubBookTile(
              book: book,
              clubCount: 1, // Single club per book in this view
              isMyClub: true,
              onViewClub: () => _navigateToClubDetails(context, club.id),
              onJoinClub: () => {}, // Already in club
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
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
            Text(
              'Error loading clubs',
              style: const TextStyle(fontSize: 18, color: Pallete.greyColor),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(fontSize: 14, color: Pallete.greyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
