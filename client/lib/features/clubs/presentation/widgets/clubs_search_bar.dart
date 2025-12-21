import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';

class ClubsSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const ClubsSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Pallete.borderColor),
      ),
      child: TextField(
        onSubmitted: onSearch,
        decoration: const InputDecoration(
          hintText: 'Search clubs or books...',
          hintStyle: TextStyle(color: Pallete.greyColor),
          prefixIcon: Icon(Icons.search, color: Pallete.greyColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
