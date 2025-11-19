import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/presentation/providers/books_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksSearchPage extends ConsumerStatefulWidget {
  const BooksSearchPage({super.key});

  @override
  ConsumerState<BooksSearchPage> createState() => _BooksSearchPageState();
}

class _BooksSearchPageState extends ConsumerState<BooksSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _searchQuery.isNotEmpty
        ? ref.watch(bookSearchProvider(_searchQuery))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        backgroundColor: Pallete.greenColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for books...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: searchResults == null
                ? const Center(
                    child: Text(
                      'Enter a search query to find books',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : searchResults.when(
                    data: (books) {
                      if (books.isEmpty) {
                        return const Center(
                          child: Text(
                            'No books found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: books.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            child: ListTile(
                              leading: book.coverImage != null
                                  ? Image.network(
                                      book.coverImage!,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.book, size: 50),
                                    )
                                  : const Icon(Icons.book, size: 50),
                              title: Text(
                                book.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (book.author != null)
                                    Text('by ${book.author}'),
                                  if (book.pages != null)
                                    Text('${book.pages} pages'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                color: Pallete.greenColor,
                                onPressed: () {
                                  // Add book to library
                                  _addBook(book);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${error.toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _addBook(book) async {
    final repository = ref.read(booksRepositoryProvider);
    final result = await repository.addBook(book);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (addedBook) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the books list
          ref.invalidate(booksListProvider);
        }
      },
    );
  }
}
