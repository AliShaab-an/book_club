import 'package:flutter/material.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/ai_message.dart';
import '../widgets/ai_empty_state.dart';
import '../widgets/ai_quick_actions.dart';
import '../widgets/ai_chat_message_bubble.dart';
import '../widgets/ai_typing_indicator.dart';
import '../widgets/ai_input_bar.dart';

class AiAssistantPage extends StatefulWidget {
  final String? bookTitle;
  final String? bookId;

  const AiAssistantPage({super.key, this.bookTitle, this.bookId});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final List<AiMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleQuickAction(String action) {
    final prompt = _getPromptForAction(action);
    _sendMessage(prompt);
  }

  String _getPromptForAction(String action) {
    final bookContext = widget.bookTitle != null
        ? ' for "${widget.bookTitle}"'
        : '';

    switch (action) {
      case 'Summarize Book':
        return 'Can you provide a summary$bookContext?';
      case 'Discussion Questions':
        return 'Generate discussion questions$bookContext';
      case 'Explain Concept':
        return 'Explain a key concept$bookContext';
      case 'Recommend Similar':
        return 'Recommend books similar to$bookContext';
      default:
        return action;
    }
  }

  void _sendMessage([String? text]) {
    final message = text ?? _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        AiMessage(
          id: DateTime.now().toString(),
          text: message,
          role: AiRole.user,
          createdAt: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _controller.clear();

    // Simulate AI response
    // TODO: Replace with actual API call to backend (FastAPI/OpenAI)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _messages.insert(
          0,
          AiMessage(
            id: DateTime.now().toString(),
            text: _generateMockResponse(message),
            role: AiRole.assistant,
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    });
  }

  String _generateMockResponse(String userMessage) {
    // Mock responses for demonstration
    if (userMessage.toLowerCase().contains('summary')) {
      return 'Here\'s a brief summary: This is a mock response. In production, this will be replaced with an actual AI-generated summary from your backend API.';
    } else if (userMessage.toLowerCase().contains('question')) {
      return '1. What themes resonate with you?\n2. How do the characters evolve?\n3. What message does the author convey?\n\n(Mock questions - will be AI-generated)';
    } else if (userMessage.toLowerCase().contains('recommend')) {
      return 'Based on this book, you might enjoy:\n- Similar Book 1\n- Similar Book 2\n- Similar Book 3\n\n(Mock recommendations - will be AI-generated)';
    } else {
      return 'I understand your question. This is a mock response. Connect me to your OpenAI backend to get real AI-powered answers!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
        title: const Text(
          'AI Assistant',
          style: TextStyle(
            color: Pallete.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Pallete.blackColor),
      ),
      body: Column(
        children: [
          // Book context header
          if (widget.bookTitle != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Pallete.greenColor.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.menu_book, size: 16, color: Pallete.greenColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Talking about: ${widget.bookTitle}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Pallete.greenColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // Quick actions
          if (_messages.isEmpty)
            AiQuickActions(onActionTap: _handleQuickAction),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? const AiEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == 0) {
                        return const AiTypingIndicator();
                      }
                      final messageIndex = _isTyping ? index - 1 : index;
                      return AiChatMessageBubble(
                        message: _messages[messageIndex],
                      );
                    },
                  ),
          ),

          // Input bar
          AiInputBar(
            controller: _controller,
            onSend: () => _sendMessage(),
            isLoading: _isTyping,
          ),
        ],
      ),
    );
  }
}
