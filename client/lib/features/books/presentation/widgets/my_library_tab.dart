import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/presentation/widgets/library_book_tile.dart';
import 'package:client/features/books/presentation/widgets/library_status_filter.dart';
import 'package:client/features/books/presentation/providers/books_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';

class MyLibraryTab extends ConsumerStatefulWidget {
  const MyLibraryTab({super.key});

  @override
  ConsumerState<MyLibraryTab> createState() => _MyLibraryTabState();
}

class _MyLibraryTabState extends ConsumerState<MyLibraryTab> {
  ReadingStatus _selectedStatus = ReadingStatus.reading;

  void _handleBookTap(String bookId) {
    // TODO: Navigate to BookDetailsPage
    print('Navigate to book: $bookId');
  }

  void _handleAction(String bookId, String action) {
    // TODO: Implement move/remove actions
    print('Action $action for book $bookId');

    if (action == 'move') {
      _showMoveDialog(bookId);
    } else if (action == 'remove') {
      _showRemoveDialog(bookId);
    }
  }

  void _showMoveDialog(String bookId) {
    // TODO: Implement move dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move Book'),
        content: const Text('Move to which status?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(String bookId) {
    // TODO: Implement remove dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Book'),
        content: const Text('Are you sure you want to remove this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Remove book logic
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(userLibraryProvider);

    return booksAsync.when(
      data: (books) {
        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: Pallete.greyColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No books in your library yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Pallete.greyColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join clubs and add books to build your library',
                  style: TextStyle(fontSize: 14, color: Pallete.greyColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Status Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: LibraryStatusFilter(
                selectedStatus: _selectedStatus,
                onStatusChanged: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),
            ),

            // Books List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];

                  return LibraryBookTile(
                    book: book,
                    status: 'Reading',
                    progress: null,
                    onTap: () => _handleBookTap(book.id),
                    onActionSelected: (action) =>
                        _handleAction(book.id, action),
                  );
                },
              ),
            ),
          ],
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
            const Text(
              'Error loading library',
              style: TextStyle(fontSize: 18, color: Pallete.greyColor),
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
