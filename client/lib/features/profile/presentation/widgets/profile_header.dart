import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/app_user.dart';
import 'profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final AppUser user;
  final VoidCallback onEditPressed;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        border: Border(bottom: BorderSide(color: Pallete.borderColor)),
      ),
      child: Column(
        children: [
          ProfileAvatar(avatarUrl: user.avatarUrl, name: user.name, size: 100),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(fontSize: 14, color: Pallete.greyColor),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Pallete.greenColor,
              side: BorderSide(color: Pallete.greenColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
