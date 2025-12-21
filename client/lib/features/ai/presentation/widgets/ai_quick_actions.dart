import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';

class AiQuickActions extends StatelessWidget {
  final Function(String) onActionTap;

  const AiQuickActions({super.key, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'label': 'Summarize Book', 'icon': Icons.summarize},
      {'label': 'Discussion Questions', 'icon': Icons.question_answer},
      {'label': 'Explain Concept', 'icon': Icons.lightbulb_outline},
      {'label': 'Recommend Similar', 'icon': Icons.recommend},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: actions.map((action) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      action['icon'] as IconData,
                      size: 18,
                      color: Pallete.greenColor,
                    ),
                    const SizedBox(width: 6),
                    Text(action['label'] as String),
                  ],
                ),
                onPressed: () => onActionTap(action['label'] as String),
                backgroundColor: Pallete.whiteColor,
                side: BorderSide(color: Pallete.greenColor),
                labelStyle: TextStyle(
                  color: Pallete.greenColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
