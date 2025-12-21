import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';

class ProfileMenuSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const ProfileMenuSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Pallete.greyColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: Pallete.whiteColor,
            border: Border(
              top: BorderSide(color: Pallete.borderColor),
              bottom: BorderSide(color: Pallete.borderColor),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
