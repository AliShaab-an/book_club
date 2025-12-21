import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/ai_message.dart';
import 'package:intl/intl.dart';

class AiChatMessageBubble extends StatelessWidget {
  final AiMessage message;

  const AiChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiRole.user;
    final timeStr = DateFormat('HH:mm').format(message.createdAt);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? Pallete.greenColor : Pallete.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          border: isUser ? null : Border.all(color: Pallete.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Pallete.whiteColor : Pallete.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 11,
                color: isUser
                    ? Pallete.whiteColor.withOpacity(0.7)
                    : Pallete.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
