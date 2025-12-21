import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/club.dart';
import 'my_club_card.dart';
import 'empty_state.dart';

class MyClubsTab extends StatefulWidget {
  const MyClubsTab({super.key});

  @override
  State<MyClubsTab> createState() => _MyClubsTabState();
}

class _MyClubsTabState extends State<MyClubsTab> {
  // TODO: Replace with actual data from repository
  final List<Club> _myClubs = [
    Club(
      id: '1',
      name: 'Classic Literature Lovers',
      bookId: '101',
      bookTitle: 'Pride and Prejudice',
      bookCoverUrl: 'https://covers.openlibrary.org/b/id/8340075-L.jpg',
      genre: 'Classic',
      membersCount: 145,
      unreadCount: 5,
      createdAt: DateTime(2024, 1, 15),
    ),
    Club(
      id: '2',
      name: 'Sci-Fi Enthusiasts',
      bookId: '102',
      bookTitle: 'Dune',
      bookCoverUrl: 'https://covers.openlibrary.org/b/id/8235870-L.jpg',
      genre: 'Science Fiction',
      membersCount: 89,
      unreadCount: 0,
      createdAt: DateTime(2024, 2, 10),
    ),
    Club(
      id: '3',
      name: 'Mystery Book Club',
      bookId: '103',
      bookTitle: 'The Silent Patient',
      bookCoverUrl: 'https://covers.openlibrary.org/b/id/8735655-L.jpg',
      genre: 'Mystery',
      membersCount: 67,
      unreadCount: 12,
      createdAt: DateTime(2024, 3, 5),
    ),
  ];

  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // TODO: Call repository to fetch updated clubs
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _navigateToClubDetails(String clubId) {
    // TODO: Navigate to ClubDetailsPage or ClubDiscussionPage
    // Navigator.pushNamed(context, '/clubs/$clubId');
  }

  @override
  Widget build(BuildContext context) {
    if (_myClubs.isEmpty) {
      return const EmptyState(
        icon: Icons.groups_outlined,
        title: 'No Clubs Yet',
        message: 'Join a club to start reading and discussing with others!',
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Pallete.greenColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _myClubs.length,
        itemBuilder: (context, index) {
          final club = _myClubs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MyClubCard(
              club: club,
              onTap: () => _navigateToClubDetails(club.id),
            ),
          );
        },
      ),
    );
  }
}
