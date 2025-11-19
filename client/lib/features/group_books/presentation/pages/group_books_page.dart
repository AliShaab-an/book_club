import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/presentation/providers/books_providers.dart';
import 'package:client/features/group_books/presentation/providers/group_books_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupBooksPage extends ConsumerWidget {
  final String groupId;
  final String groupName;

  const GroupBooksPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupBooksAsync = ref.watch(groupBooksProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text('$groupName - Books'),
        backgroundColor: Pallete.greenColor,
      ),
      body: groupBooksAsync.when(
        data: (groupBooks) {
          if (groupBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No books selected yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add books to start reading together',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showSelectBookDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.greenColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupBooksProvider(groupId));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupBooks.length,
              itemBuilder: (context, index) {
                final groupBook = groupBooks[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(groupBook.status),
                      child: Icon(
                        _getStatusIcon(groupBook.status),
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Book ID: ${groupBook.bookId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${_getStatusText(groupBook.status)}',
                          style: TextStyle(
                            color: _getStatusColor(groupBook.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Added: ${_formatDate(groupBook.selectedDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'reading',
                          child: Row(
                            children: [
                              Icon(Icons.play_circle, size: 20),
                              SizedBox(width: 8),
                              Text('Mark as Reading'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'finished',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 20),
                              SizedBox(width: 8),
                              Text('Mark as Finished'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        _updateBookStatus(
                          context,
                          ref,
                          groupBook.bookId,
                          value as String,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error loading books',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(groupBooksProvider(groupId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSelectBookDialog(context, ref),
        backgroundColor: Pallete.greenColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSelectBookDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Book to Group'),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer(
            builder: (context, ref, child) {
              final booksAsync = ref.watch(booksListProvider);

              return booksAsync.when(
                data: (books) {
                  if (books.isEmpty) {
                    return const Center(
                      child: Text('No books available. Add some books first!'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return ListTile(
                        leading: book.coverImage != null
                            ? Image.network(
                                book.coverImage!,
                                width: 40,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.book),
                              )
                            : const Icon(Icons.book),
                        title: Text(book.title),
                        subtitle: book.author != null
                            ? Text(book.author!)
                            : null,
                        onTap: () async {
                          Navigator.pop(context);
                          await _addBookToGroup(context, ref, book.id);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('Error: $error'),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _addBookToGroup(
    BuildContext context,
    WidgetRef ref,
    String bookId,
  ) async {
    final repository = ref.read(groupBooksRepositoryProvider);
    final result = await repository.selectBookForGroup(
      groupId: groupId,
      bookId: bookId,
      status: 'not_started',
    );

    result.fold(
      (failure) {
        Fluttertoast.showToast(
          msg: failure.errMessage,
          backgroundColor: Colors.red,
        );
      },
      (groupBook) {
        Fluttertoast.showToast(
          msg: 'Book added to group successfully!',
          backgroundColor: Colors.green,
        );
        ref.invalidate(groupBooksProvider(groupId));
      },
    );
  }

  Future<void> _updateBookStatus(
    BuildContext context,
    WidgetRef ref,
    String bookId,
    String newStatus,
  ) async {
    final repository = ref.read(groupBooksRepositoryProvider);
    final result = await repository.selectBookForGroup(
      groupId: groupId,
      bookId: bookId,
      status: newStatus,
    );

    result.fold(
      (failure) {
        Fluttertoast.showToast(
          msg: failure.errMessage,
          backgroundColor: Colors.red,
        );
      },
      (groupBook) {
        Fluttertoast.showToast(
          msg: 'Status updated successfully!',
          backgroundColor: Colors.green,
        );
        ref.invalidate(groupBooksProvider(groupId));
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'reading':
        return Colors.blue;
      case 'finished':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'reading':
        return Icons.play_circle;
      case 'finished':
        return Icons.check_circle;
      default:
        return Icons.schedule;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'reading':
        return 'Currently Reading';
      case 'finished':
        return 'Finished';
      default:
        return 'Not Started';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
