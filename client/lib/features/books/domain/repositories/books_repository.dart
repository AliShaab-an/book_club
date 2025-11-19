import 'package:client/core/errors/failure.dart';
import 'package:client/features/books/domain/entities/book.dart';
import 'package:fpdart/fpdart.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> searchBooks(String query);
  Future<Either<Failure, Book>> addBook(Book book);
  Future<Either<Failure, List<Book>>> getBooks();
}
