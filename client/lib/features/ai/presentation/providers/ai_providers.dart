import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import '../../data/services/openai_service.dart';

final openAIServiceProvider = Provider<OpenAIService>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return OpenAIService(httpService: httpService, tokenManager: tokenManager);
});
