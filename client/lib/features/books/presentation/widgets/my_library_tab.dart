import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/presentation/widgets/library_book_tile.dart';
import 'package:client/features/books/presentation/widgets/library_status_filter.dart';
import 'package:flutter/material.dart';

class MyLibraryTab extends StatefulWidget {
  const MyLibraryTab({super.key});

  @override
  State<MyLibraryTab> createState() => _MyLibraryTabState();
}

class _MyLibraryTabState extends State<MyLibraryTab> {
  ReadingStatus _selectedStatus = ReadingStatus.reading;

  // TODO: Replace with actual data from repository/API
  final Map<ReadingStatus, List<Map<String, dynamic>>> _libraryBooks = {
    ReadingStatus.wantToRead: [
      {
        'book': const Book(
          id: '1',
          title: 'The Midnight Library',
          author: 'Matt Haig',
          coverImage: null,
        ),
        'status': 'Want to Read',
      },
    ],
    ReadingStatus.reading: [
      {
        'book': const Book(
          id: '2',
          title: 'Atomic Habits',
          author: 'James Clear',
          coverImage: null,
        ),
        'status': 'Reading',
        'progress': 0.65,
      },
      {
        'book': const Book(
          id: '3',
          title: 'Project Hail Mary',
          author: 'Andy Weir',
          coverImage: null,
        ),
        'status': 'Reading',
        'progress': 0.32,
      },
    ],
    ReadingStatus.finished: [
      {
        'book': const Book(
          id: '4',
          title: 'The Silent Patient',
          author: 'Alex Michaelides',
          coverImage: null,
        ),
        'status': 'Finished',
      },
    ],
  };

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
    final books = _libraryBooks[_selectedStatus] ?? [];

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
          child: books.isEmpty
              ? const Center(
                  child: Text(
                    'No books in this category',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final item = books[index];
                    final book = item['book'] as Book;
                    final status = item['status'] as String;
                    final progress = item['progress'] as double?;

                    return LibraryBookTile(
                      book: book,
                      status: status,
                      progress: progress,
                      onTap: () => _handleBookTap(book.id),
                      onActionSelected: (action) =>
                          _handleAction(book.id, action),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
