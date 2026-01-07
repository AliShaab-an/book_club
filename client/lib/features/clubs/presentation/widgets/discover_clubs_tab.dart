import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'clubs_search_bar.dart';
import 'popular_clubs_section.dart';
import '../providers/clubs_providers.dart';
import 'discover_club_card.dart';
import 'package:client/core/utils/app_colors.dart';

class DiscoverClubsTab extends ConsumerStatefulWidget {
  const DiscoverClubsTab({super.key});

  @override
  ConsumerState<DiscoverClubsTab> createState() => _DiscoverClubsTabState();
}

class _DiscoverClubsTabState extends ConsumerState<DiscoverClubsTab> {
  String _searchQuery = '';

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  void _joinClub(String clubId) {
    // TODO: Implement join club functionality
    ref.read(joinClubProvider(clubId));
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
        if (_searchQuery.isEmpty)
          const PopularClubsSection()
        else
          _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchResults() {
    final searchResults = ref.watch(searchClubsProvider(_searchQuery));

    return searchResults.when(
      data: (clubs) {
        if (clubs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 64, color: Pallete.greyColor),
                  SizedBox(height: 16),
                  Text(
                    'No clubs found',
                    style: TextStyle(fontSize: 18, color: Pallete.greyColor),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Search Results (${clubs.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Pallete.blackColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: clubs.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final club = clubs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DiscoverClubCard(
                    club: club,
                    onJoin: () => _joinClub(club.id),
                  ),
                );
              },
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Pallete.errorColor),
          ),
        ),
      ),
    );
  }
}
