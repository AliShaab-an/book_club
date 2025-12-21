import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_notifier.dart';
import 'package:client/features/books/presentation/providers/books_providers.dart';
import 'package:client/features/groups/presentation/providers/groups_providers.dart';
import 'package:client/features/home/presentation/widgets/ai_assistant_card.dart';
import 'package:client/features/home/presentation/widgets/continue_reading_card.dart';
import 'package:client/features/home/presentation/widgets/home_header.dart';
import 'package:client/features/home/presentation/widgets/my_clubs_section.dart';
import 'package:client/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:client/features/home/presentation/widgets/recommended_books_section.dart';
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
                            onTap: () {
                              // TODO: Navigate to book details
                            },
                          )
                        : null,
                  ) ??
                  const SizedBox.shrink(),

              const SizedBox(height: 20),

              // Quick Actions Row
              QuickActionsRow(
                onSearchBooks: () {
                  // TODO: Navigate to search books page
                },
                onBrowseClubs: () {
                  // TODO: Navigate to browse clubs page
                },
                onMyBooks: () {
                  // TODO: Navigate to my books page
                },
              ),

              const SizedBox(height: 24),

              // AI Assistant Card
              AiAssistantCard(
                onTap: () {
                  // TODO: Navigate to AI assistant page
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
}
