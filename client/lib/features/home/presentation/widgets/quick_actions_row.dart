import 'package:client/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback? onSearchBooks;
  final VoidCallback? onBrowseClubs;
  final VoidCallback? onMyBooks;

  const QuickActionsRow({
    super.key,
    this.onSearchBooks,
    this.onBrowseClubs,
    this.onMyBooks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.search,
          label: 'Search\nBooks',
          onTap: onSearchBooks,
        ),
        _ActionButton(
          icon: Icons.group,
          label: 'Browse\nClubs',
          onTap: onBrowseClubs,
        ),
        _ActionButton(
          icon: Icons.library_books,
          label: 'My\nBooks',
          onTap: onMyBooks,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: Pallete.whiteColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: Pallete.greenColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Pallete.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
