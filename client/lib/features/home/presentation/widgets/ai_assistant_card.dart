import 'package:client/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AiAssistantCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AiAssistantCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Pallete.greenColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Pallete.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Pallete.greenColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Reading Assistant',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Get personalized book recommendations',
                      style: TextStyle(color: Pallete.whiteColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Pallete.whiteColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
