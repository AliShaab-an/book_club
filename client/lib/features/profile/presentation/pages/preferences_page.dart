import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';

class PreferencesPage extends StatefulWidget {
  final List<String> selectedGenres;

  const PreferencesPage({super.key, this.selectedGenres = const []});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  // TODO: Replace with actual genres from API
  final List<String> _availableGenres = [
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Thriller',
    'Romance',
    'Science Fiction',
    'Fantasy',
    'Horror',
    'Biography',
    'History',
    'Self-Help',
    'Business',
    'Poetry',
    'Drama',
    'Adventure',
    'Comedy',
    'Crime',
    'Philosophy',
  ];

  late Set<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    _selectedGenres = Set.from(widget.selectedGenres);
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  void _savePreferences() {
    // TODO: Call API to save preferences
    Navigator.pop(context, _selectedGenres.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
        title: const Text(
          'Favorite Genres',
          style: TextStyle(
            color: Pallete.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Pallete.blackColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select your favorite genres to get better recommendations',
              style: TextStyle(fontSize: 14, color: Pallete.greyColor),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (_) => _toggleGenre(genre),
                    backgroundColor: Pallete.whiteColor,
                    selectedColor: Pallete.greenColor,
                    checkmarkColor: Pallete.whiteColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Pallete.whiteColor
                          : Pallete.blackColor,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Pallete.greenColor
                          : Pallete.borderColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              border: Border(top: BorderSide(color: Pallete.borderColor)),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.greenColor,
                  foregroundColor: Pallete.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(
                  'Save Preferences (${_selectedGenres.length} selected)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
