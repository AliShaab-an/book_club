import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import 'clubs_search_bar.dart';
import 'popular_clubs_section.dart';
import 'clubs_by_genre_section.dart';

class DiscoverClubsTab extends StatefulWidget {
  const DiscoverClubsTab({super.key});

  @override
  State<DiscoverClubsTab> createState() => _DiscoverClubsTabState();
}

class _DiscoverClubsTabState extends State<DiscoverClubsTab> {
  void _handleSearch(String query) {
    // TODO: Implement search functionality
    // Call repository to search clubs by name or book title
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClubsSearchBar(onSearch: _handleSearch),
        ),
        const SizedBox(height: 24),
        const PopularClubsSection(),
        const SizedBox(height: 24),
        const ClubsByGenreSection(),
      ],
    );
  }
}
