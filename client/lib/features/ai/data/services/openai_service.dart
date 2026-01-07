import 'package:client/core/errors/failure.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:fpdart/fpdart.dart';

class OpenAIService {
  final HttpService httpService;
  final TokenManager tokenManager;

  OpenAIService({required this.httpService, required this.tokenManager});

  Future<String> sendMessage({
    required String message,
    required List<Map<String, String>> conversationHistory,
    String? bookTitle,
    String? bookContext,
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      print('DEBUG: Calling AI API with message: ${message.substring(0, message.length > 50 ? 50 : message.length)}...');
      
      final result = await httpService.post('/ai/chat', {
        'message': message,
        'conversation_history': conversationHistory,
        'book_title': bookTitle,
        'book_context': bookContext,
      }, token: token);

      return result.fold(
        (failure) {
          print('DEBUG: AI API Error - ${failure.errMessage}');
          throw Exception('AI Error: ${failure.errMessage}');
        },
        (data) {
          print('DEBUG: AI API Success');
          return data['response'] as String;
        },
      );
    } catch (e) {
      print('Error calling AI API: $e');
      rethrow;
    }
  }

  Future<List<String>> getBookRecommendations({
    required String bookTitle,
    int count = 5,
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final result = await httpService.post('/ai/recommendations', {
        'book_title': bookTitle,
        'count': count,
      }, token: token);

      return result.fold((failure) {
        print('Error getting recommendations: ${failure.errMessage}');
        return <String>[];
      }, (data) => List<String>.from(data['recommendations']));
    } catch (e) {
      print('Error getting recommendations: $e');
      return [];
    }
  }

  Future<String> generateBookSummary({required String bookTitle}) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final result = await httpService.post('/ai/summary', {
        'book_title': bookTitle,
      }, token: token);

      return result.fold(
        (failure) => throw Exception(failure.errMessage),
        (data) => data['summary'] as String,
      );
    } catch (e) {
      print('Error generating summary: $e');
      rethrow;
    }
  }

  Future<List<String>> generateDiscussionQuestions({
    required String bookTitle,
    int count = 5,
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final result = await httpService.post('/ai/discussion-questions', {
        'book_title': bookTitle,
        'count': count,
      }, token: token);

      return result.fold((failure) {
        print('Error generating questions: ${failure.errMessage}');
        return <String>[];
      }, (data) => List<String>.from(data['questions']));
    } catch (e) {
      print('Error generating questions: $e');
      return [];
    }
  }
}
