import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/books/domain/entities/book.dart';

class CreateClubDialog extends StatefulWidget {
  final Function(String name, String? description, Book book) onCreateClub;

  const CreateClubDialog({super.key, required this.onCreateClub});

  @override
  State<CreateClubDialog> createState() => _CreateClubDialogState();
}

class _CreateClubDialogState extends State<CreateClubDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Book? _selectedBook;
  List<Book> _searchResults = [];

  // Dummy books for selection
  final List<Book> _dummyBooks = [
    const Book(
      id: '1',
      title: 'The Midnight Library',
      author: 'Matt Haig',
      description: 'A novel about infinite possibilities',
      coverImage: 'https://covers.openlibrary.org/b/id/12345678-L.jpg',
    ),
    const Book(
      id: '2',
      title: 'Atomic Habits',
      author: 'James Clear',
      description: 'An easy way to build good habits',
      coverImage: 'https://covers.openlibrary.org/b/id/8629207-L.jpg',
    ),
    const Book(
      id: '3',
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      description: 'A lone astronaut must save Earth',
      coverImage: 'https://covers.openlibrary.org/b/id/8235869-L.jpg',
    ),
    const Book(
      id: '4',
      title: 'The Seven Husbands of Evelyn Hugo',
      author: 'Taylor Jenkins Reid',
      description: 'A story of Hollywood glamour',
      coverImage: 'https://covers.openlibrary.org/b/id/8340075-L.jpg',
    ),
    const Book(
      id: '5',
      title: 'Educated',
      author: 'Tara Westover',
      description: 'A memoir about education and family',
      coverImage: 'https://covers.openlibrary.org/b/id/8455773-L.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = _dummyBooks;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _searchBooks(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _dummyBooks;
      } else {
        _searchResults = _dummyBooks
            .where(
              (book) =>
                  book.title.toLowerCase().contains(query.toLowerCase()) ||
                  (book.author?.toLowerCase().contains(query.toLowerCase()) ??
                      false),
            )
            .toList();
      }
    });
  }

  void _showBookSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Pallete.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Pallete.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select a Book',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Pallete.blackColor,
                  ),
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: _searchBooks,
                  decoration: InputDecoration(
                    hintText: 'Search books...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Pallete.greyColor,
                    ),
                    filled: true,
                    fillColor: Pallete.borderColor.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Books list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final book = _searchResults[index];
                    final isSelected = _selectedBook?.id == book.id;
                    return Card(
                      elevation: 0,
                      color: isSelected
                          ? Pallete.greenColor.withOpacity(0.1)
                          : Pallete.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? Pallete.greenColor
                              : Pallete.borderColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBook = book;
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Book cover
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: book.coverImage != null
                                    ? Image.network(
                                        book.coverImage!,
                                        width: 50,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 50,
                                                height: 75,
                                                color: Pallete.borderColor,
                                                child: const Icon(
                                                  Icons.book,
                                                  color: Pallete.greyColor,
                                                ),
                                              );
                                            },
                                      )
                                    : Container(
                                        width: 50,
                                        height: 75,
                                        color: Pallete.borderColor,
                                        child: const Icon(
                                          Icons.book,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              // Book info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Pallete.blackColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (book.author != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        book.author!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Pallete.greyColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Pallete.greenColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateClub() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBook == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a book for this club'),
            backgroundColor: Pallete.errorColor,
          ),
        );
        return;
      }

      widget.onCreateClub(
        _nameController.text.trim(),
        _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        _selectedBook!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Pallete.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Pallete.greenColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.group_add,
                        color: Pallete.greenColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Create New Club',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Pallete.blackColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start a new book club and invite others to join',
                  style: TextStyle(fontSize: 14, color: Pallete.greyColor),
                ),
                const SizedBox(height: 24),

                // Club Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Club Name *',
                    hintText: 'e.g., Mystery Lovers Club',
                    prefixIcon: Icon(Icons.groups, color: Pallete.greenColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Pallete.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Pallete.greenColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a club name';
                    }
                    if (value.trim().length < 3) {
                      return 'Club name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Tell others about your club...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Icon(Icons.description, color: Pallete.greenColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Pallete.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Pallete.greenColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Book Selection
                InkWell(
                  onTap: _showBookSelectionBottomSheet,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.book,
                          color: _selectedBook != null
                              ? Pallete.greenColor
                              : Pallete.greyColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedBook != null
                                    ? _selectedBook!.title
                                    : 'Select a Book *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: _selectedBook != null
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: _selectedBook != null
                                      ? Pallete.blackColor
                                      : Pallete.greyColor,
                                ),
                              ),
                              if (_selectedBook?.author != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  _selectedBook!.author!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Pallete.greyColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Pallete.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Pallete.greyColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _handleCreateClub,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.greenColor,
                        foregroundColor: Pallete.whiteColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Club',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
