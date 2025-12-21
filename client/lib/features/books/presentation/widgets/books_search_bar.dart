import 'package:client/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BooksSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;

  const BooksSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Pallete.subtitleText.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Pallete.subtitleText, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSearch?.call(),
              decoration: const InputDecoration(
                hintText: 'Search books...',
                hintStyle: TextStyle(color: Pallete.subtitleText, fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(color: Pallete.blackColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
