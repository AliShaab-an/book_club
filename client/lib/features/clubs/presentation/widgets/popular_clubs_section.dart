import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/club.dart';
import 'discover_club_card.dart';

class PopularClubsSection extends StatefulWidget {
  const PopularClubsSection({super.key});

  @override
  State<PopularClubsSection> createState() => _PopularClubsSectionState();
}

class _PopularClubsSectionState extends State<PopularClubsSection> {
  // TODO: Replace with actual data from repository
  final List<Club> _popularClubs = [
    Club(
      id: '10',
      name: 'Fantasy Readers Unite',
      bookId: '201',
      bookTitle: 'The Name of the Wind',
      bookCoverUrl: 'https://covers.openlibrary.org/b/id/8629207-L.jpg',
      genre: 'Fantasy',
      membersCount: 234,
      createdAt: DateTime(2023, 11, 1),
    ),
    Club(
      id: '11',
      name: 'Thriller Seekers',
      bookId: '202',
      bookTitle: 'Gone Girl',
      bookCoverUrl: 'https://covers.openlibrary.org/b/id/8235869-L.jpg',
      genre: 'Thriller',
      membersCount: 189,
      createdAt: DateTime(2023, 12, 5),
    ),
    Club(
      id: '12',
      name: 'Historical Fiction Club',
      bookId: '203',
      bookTitle: 'All the Light We Cannot See',
      bookCoverUrl: 'https://covers.openlibrary.org/b/id/8455773-L.jpg',
      genre: 'Historical Fiction',
      membersCount: 156,
      createdAt: DateTime(2024, 1, 10),
    ),
  ];

  void _joinClub(Club club) {
    // TODO: Call repository to join club
    // Then navigate to ClubDetailsPage
    // Navigator.pushNamed(context, '/clubs/${club.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Clubs',
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
            itemCount: _popularClubs.length,
            itemBuilder: (context, index) {
              final club = _popularClubs[index];
              return Container(
                width: 320,
                margin: const EdgeInsets.only(right: 12),
                child: DiscoverClubCard(
                  club: club,
                  onJoin: () => _joinClub(club),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
