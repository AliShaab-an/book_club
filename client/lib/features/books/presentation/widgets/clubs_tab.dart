import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/presentation/widgets/club_book_tile.dart';
import 'package:flutter/material.dart';

class ClubsTab extends StatelessWidget {
  const ClubsTab({super.key});

  // TODO: Replace with actual data from repository/API
  List<Map<String, dynamic>> get _clubBooks => [
    {
      'book': const Book(
        id: '1',
        title: 'The Midnight Library',
        author: 'Matt Haig',
        coverImage: null,
      ),
      'clubCount': 3,
      'isMyClub': true,
    },
    {
      'book': const Book(
        id: '2',
        title: 'Atomic Habits',
        author: 'James Clear',
        coverImage: null,
      ),
      'clubCount': 5,
      'isMyClub': false,
    },
    {
      'book': const Book(
        id: '3',
        title: 'Project Hail Mary',
        author: 'Andy Weir',
        coverImage: null,
      ),
      'clubCount': 2,
      'isMyClub': true,
    },
  ];

  void _navigateToClubDetails(String bookId) {
    // TODO: Navigate to ClubDetailsPage
    print('Navigate to club details for book: $bookId');
  }

  void _navigateToClubsExplore(String bookId) {
    // TODO: Navigate to ClubsExplorePage
    print('Navigate to clubs explore for book: $bookId');
  }

  @override
  Widget build(BuildContext context) {
    if (_clubBooks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No club books yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Join a club to see books here',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _clubBooks.length,
      itemBuilder: (context, index) {
        final item = _clubBooks[index];
        final book = item['book'] as Book;
        final clubCount = item['clubCount'] as int;
        final isMyClub = item['isMyClub'] as bool;

        return ClubBookTile(
          book: book,
          clubCount: clubCount,
          isMyClub: isMyClub,
          onViewClub: () => _navigateToClubDetails(book.id),
          onJoinClub: () => _navigateToClubsExplore(book.id),
        );
      },
    );
  }
}
