import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/club.dart';
import '../../domain/utils/dummy_clubs_data.dart';
import 'discover_club_card.dart';

class ClubsByGenreSection extends StatefulWidget {
  const ClubsByGenreSection({super.key});

  @override
  State<ClubsByGenreSection> createState() => _ClubsByGenreSectionState();
}

class _ClubsByGenreSectionState extends State<ClubsByGenreSection> {
  late List<String> _genres;
  late Map<String, List<Club>> _clubsByGenre;
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    // Load dummy data
    _clubsByGenre = DummyClubsData.generateClubsByGenre();
    _genres = [
      'All',
      ..._clubsByGenre.keys.where((k) => k != 'All').toList()..sort(),
    ];
  }

  void _joinClub(Club club) {
    // TODO: Call repository to join club
    // Then navigate to ClubDetailsPage
    // Navigator.pushNamed(context, '/clubs/${club.id}');
  }

  @override
  Widget build(BuildContext context) {
    final clubs = _clubsByGenre[_selectedGenre] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Clubs by Genre',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Genre Chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _genres.length,
            itemBuilder: (context, index) {
              final genre = _genres[index];
              final isSelected = genre == _selectedGenre;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedGenre = genre;
                      });
                    }
                  },
                  backgroundColor: Pallete.whiteColor,
                  selectedColor: Pallete.greenColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Pallete.whiteColor : Pallete.greyColor,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? Pallete.greenColor
                        : Pallete.borderColor,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Clubs List
        if (clubs.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No clubs found in this genre',
                style: TextStyle(fontSize: 14, color: Pallete.greyColor),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              final club = clubs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DiscoverClubCard(
                  club: club,
                  onJoin: () => _joinClub(club),
                ),
              );
            },
          ),
      ],
    );
  }
}
