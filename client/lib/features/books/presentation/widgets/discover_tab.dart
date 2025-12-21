import 'package:client/features/books/presentation/pages/books_search_page.dart';
import 'package:client/features/books/presentation/providers/books_providers.dart';
import 'package:client/features/books/presentation/widgets/books_search_bar.dart';
import 'package:client/features/books/presentation/widgets/trending_books_section.dart';
import 'package:client/features/home/presentation/widgets/recommended_books_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverTab extends ConsumerStatefulWidget {
  const DiscoverTab({super.key});

  @override
  ConsumerState<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends ConsumerState<DiscoverTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const BooksSearchPage()));
    }
  }

  void _navigateToBookDetails(String bookId) {
    // TODO: Navigate to BookDetailsPage
    print('Navigate to book: $bookId');
  }

  @override
  Widget build(BuildContext context) {
    final trendingBooksAsync = ref.watch(trendingBooksProvider);
    final recommendedBooksAsync = ref.watch(recommendedBooksProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BooksSearchPage(),
                ),
              );
            },
            child: AbsorbPointer(
              child: BooksSearchBar(
                controller: _searchController,
                onChanged: _handleSearch,
                onSearch: () => _handleSearch(_searchController.text),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Trending Books Section
          trendingBooksAsync.when(
            data: (books) => TrendingBooksSection(
              books: books,
              onBookTap: _navigateToBookDetails,
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Error loading trending books',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Recommended Books Section
          recommendedBooksAsync.when(
            data: (books) => RecommendedBooksSection(
              books: books,
              onBookTap: () {
                // Will be called with book ID in implementation
              },
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Error loading recommended books',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
