import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';
import '../../domain/entities/ai_message.dart';
import '../widgets/ai_empty_state.dart';
import '../widgets/ai_quick_actions.dart';
import '../widgets/ai_chat_message_bubble.dart';
import '../widgets/ai_typing_indicator.dart';
import '../widgets/ai_input_bar.dart';
import '../providers/ai_providers.dart';

class AiAssistantPage extends ConsumerStatefulWidget {
  final String? bookTitle;
  final String? bookId;

  const AiAssistantPage({super.key, this.bookTitle, this.bookId});

  @override
  ConsumerState<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends ConsumerState<AiAssistantPage> {
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

    // Call OpenAI API
    _callOpenAI(message);
  }

  Future<void> _callOpenAI(String message) async {
    try {
      final openAIService = ref.read(openAIServiceProvider);

      // Build conversation history
      final conversationHistory = _messages.reversed
          .take(10) // Last 10 messages for context
          .map(
            (msg) => {
              'role': msg.role == AiRole.user ? 'user' : 'assistant',
              'content': msg.text,
            },
          )
          .toList();

      final response = await openAIService.sendMessage(
        message: message,
        conversationHistory: conversationHistory,
        bookTitle: widget.bookTitle,
      );

      if (!mounted) return;
      setState(() {
        _messages.insert(
          0,
          AiMessage(
            id: DateTime.now().toString(),
            text: response,
            role: AiRole.assistant,
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.insert(
          0,
          AiMessage(
            id: DateTime.now().toString(),
            text:
                'Sorry, I encountered an error: ${e.toString()}. Please try again.',
            role: AiRole.assistant,
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
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
