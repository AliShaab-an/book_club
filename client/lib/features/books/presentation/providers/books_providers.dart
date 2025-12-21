import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/books/data/repositories/books_repository_impl.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/domain/repositories/books_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return BooksRepositoryImpl(
    httpService: httpService,
    tokenManager: tokenManager,
  );
});

// Books List Provider
final booksListProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.read(booksRepositoryProvider);
  final result = await repository.getBooks();

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (books) => books,
  );
});

// Book Search Provider
final bookSearchProvider = FutureProvider.family<List<Book>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];

  final repository = ref.read(booksRepositoryProvider);
  final result = await repository.searchBooks(query);

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (books) => books,
  );
});

// Trending Books Provider - searches for popular/bestseller books
final trendingBooksProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.read(booksRepositoryProvider);
  final result = await repository.searchBooks('bestseller');

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (books) => books.take(5).toList(), // Limit to 5 books
  );
});

// Recommended Books Provider - searches for trending fiction books
final recommendedBooksProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.read(booksRepositoryProvider);
  final result = await repository.searchBooks('trending fiction');

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (books) => books.take(5).toList(), // Limit to 5 books
  );
});
