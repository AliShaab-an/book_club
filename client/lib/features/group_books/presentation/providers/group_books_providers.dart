import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/group_books/data/repositories/group_books_repository_impl.dart';
import 'package:client/features/group_books/domain/entities/group_book.dart';
import 'package:client/features/group_books/domain/repositories/group_books_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final groupBooksRepositoryProvider = Provider<GroupBooksRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return GroupBooksRepositoryImpl(
    httpService: httpService,
    tokenManager: tokenManager,
  );
});

// Group Books List Provider
final groupBooksProvider =
    FutureProvider.family<List<GroupBook>, String>((ref, groupId) async {
  final repository = ref.read(groupBooksRepositoryProvider);
  final result = await repository.getGroupBooks(groupId);

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (groupBooks) => groupBooks,
  );
});
