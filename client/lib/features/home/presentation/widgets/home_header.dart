import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final User? user;

  const HomeHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Card(
      elevation: 2,
      color: Pallete.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Pallete.greenColor,
              child: const Icon(
                Icons.person,
                size: 36,
                color: Pallete.whiteColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Pallete.blackColor,
                    ),
                  ),
                  if (user?.email != null)
                    Text(
                      user!.email,
                      style: const TextStyle(
                        color: Pallete.subtitleText,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
