import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/books/data/models/book_model.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:client/features/books/domain/repositories/books_repository.dart';
import 'package:fpdart/fpdart.dart';

class BooksRepositoryImpl implements BooksRepository {
  final HttpService httpService;
  final TokenManager tokenManager;

  BooksRepositoryImpl({required this.httpService, required this.tokenManager});

  @override
  Future<Either<Failure, List<Book>>> searchBooks(String query) async {
    try {
      final result = await httpService.get('/book/search?query=$query');

      return result.fold((failure) => Left(failure), (data) {
        // Extract the list from the wrapper if it exists
        final List<dynamic> booksJson =
            (data['data'] as List<dynamic>?) ??
            (data is List ? data as List<dynamic> : <dynamic>[]);
        final books = booksJson
            .map((json) => BookModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return Right(books);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Book>> addBook(Book book) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final bookModel = BookModel(
        id: book.id,
        title: book.title,
        author: book.author,
        description: book.description,
        coverImage: book.coverImage,
        pages: book.pages,
        source: book.source,
        externalId: book.externalId,
      );

      final result = await httpService.post(
        '/book/',
        bookModel.toMap(),
        token: token,
      );

      return result.fold((failure) => Left(failure), (data) {
        final addedBook = BookModel.fromMap(data);
        return Right(addedBook);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getBooks() async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get('/book/', token: token);

      return result.fold((failure) => Left(failure), (data) {
        // Extract the list from the wrapper if it exists
        final List<dynamic> booksJson =
            (data['data'] as List<dynamic>?) ??
            (data is List ? data as List<dynamic> : <dynamic>[]);
        final books = booksJson
            .map((json) => BookModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return Right(books);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
