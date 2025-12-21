import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    required this.name,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Pallete.greenColor.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Pallete.greenColor, width: 3),
        ),
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitials();
                  },
                ),
              )
            : _buildInitials(),
      ),
    );
  }

  Widget _buildInitials() {
    final initials = name.isNotEmpty
        ? name.split(' ').map((word) => word[0]).take(2).join().toUpperCase()
        : '?';

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: Pallete.greenColor,
        ),
      ),
    );
  }
}
