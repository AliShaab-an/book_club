import 'package:client/core/errors/failure.dart';
import 'package:client/features/group_books/domain/entities/group_book.dart';
import 'package:fpdart/fpdart.dart';

abstract class GroupBooksRepository {
  Future<Either<Failure, GroupBook>> selectBookForGroup({
    required String groupId,
    required String bookId,
    String status = 'not_started',
  });

  Future<Either<Failure, List<GroupBook>>> getGroupBooks(String groupId);
}
