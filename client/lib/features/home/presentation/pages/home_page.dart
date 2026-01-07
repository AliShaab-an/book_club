import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_notifier.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/presentation/pages/books_search_page.dart';
import 'package:client/features/books/presentation/pages/my_books_page.dart';
import 'package:client/features/books/presentation/providers/books_providers.dart';
import 'package:client/features/groups/presentation/providers/groups_providers.dart';
import 'package:client/features/home/presentation/widgets/ai_assistant_card.dart';
import 'package:client/features/home/presentation/widgets/continue_reading_card.dart';
import 'package:client/features/home/presentation/widgets/home_header.dart';
import 'package:client/features/home/presentation/widgets/my_clubs_section.dart';
import 'package:client/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:client/features/home/presentation/widgets/recommended_books_section.dart';
import 'package:client/features/main/presentation/pages/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final booksAsync = ref.watch(booksListProvider);
    final groupsAsync = ref.watch(groupsListProvider);

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'DeepReads',
          style: TextStyle(
            color: Pallete.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Pallete.greenColor,
        onRefresh: () async {
          ref.invalidate(booksListProvider);
          ref.invalidate(groupsListProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Home Header
              HomeHeader(user: authState.user),

              const SizedBox(height: 20),

              // Continue Reading Card
              booksAsync.whenOrNull(
                    data: (books) => books.isNotEmpty
                        ? ContinueReadingCard(
                            book: books.first,
                            onTap: () => _showBookDetails(context, books.first),
                          )
                        : null,
                  ) ??
                  const SizedBox.shrink(),

              const SizedBox(height: 20),

              // Quick Actions Row
              QuickActionsRow(
                onSearchBooks: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BooksSearchPage(),
                    ),
                  );
                },
                onBrowseClubs: () {
                  // Switch to Clubs tab
                  ref.read(selectedTabProvider.notifier).state = 2;
                },
                onMyBooks: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBooksPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // AI Assistant Card
              AiAssistantCard(
                onTap: () {
                  // Switch to AI Assistant tab
                  ref.read(selectedTabProvider.notifier).state = 3;
                },
              ),

              const SizedBox(height: 24),

              // Recommended Books Section
              booksAsync.when(
                data: (books) => RecommendedBooksSection(
                  books: books,
                  onBookTap: () {
                    // TODO: Navigate to book details
                  },
                ),
                loading: () =>
                    const RecommendedBooksSection(books: [], isLoading: true),
                error: (_, __) =>
                    const RecommendedBooksSection(books: [], hasError: true),
              ),

              const SizedBox(height: 24),

              // My Clubs Section
              groupsAsync.when(
                data: (clubs) => MyClubsSection(
                  clubs: clubs,
                  onClubTap: () {
                    // TODO: Navigate to club details
                  },
                ),
                loading: () => const MyClubsSection(clubs: [], isLoading: true),
                error: (_, __) =>
                    const MyClubsSection(clubs: [], hasError: true),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookDetails(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                if (book.coverImage != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      book.coverImage!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.book, size: 80),
                      ),
                    ),
                  ),
                // Book Details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Pallete.blackColor,
                        ),
                      ),
                      if (book.author != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'by ${book.author}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Pallete.subtitleText,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (book.description != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Pallete.blackColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Pallete.subtitleText,
                            height: 1.5,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Pallete.subtitleText),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to full book details or reading page
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.greenColor,
                              foregroundColor: Pallete.whiteColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Continue Reading'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
