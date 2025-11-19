import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/group_books/data/models/group_book_model.dart';
import 'package:client/features/group_books/domain/entities/group_book.dart';
import 'package:client/features/group_books/domain/repositories/group_books_repository.dart';
import 'package:fpdart/fpdart.dart';

class GroupBooksRepositoryImpl implements GroupBooksRepository {
  final HttpService httpService;
  final TokenManager tokenManager;

  GroupBooksRepositoryImpl({
    required this.httpService,
    required this.tokenManager,
  });

  @override
  Future<Either<Failure, GroupBook>> selectBookForGroup({
    required String groupId,
    required String bookId,
    String status = 'not_started',
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.post(
        '/group_book/select-book',
        {
          'group_id': groupId,
          'book_id': bookId,
          'status': status,
        },
        token: token,
      );

      return result.fold(
        (failure) => Left(failure),
        (data) {
          final groupBook = GroupBookModel.fromMap(data);
          return Right(groupBook);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupBook>>> getGroupBooks(String groupId) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get(
        '/group_book/group/$groupId',
        token: token,
      );

      return result.fold(
        (failure) => Left(failure),
        (data) {
          final List<dynamic> groupBooksJson = data as List<dynamic>;
          final groupBooks = groupBooksJson
              .map((json) =>
                  GroupBookModel.fromMap(json as Map<String, dynamic>))
              .toList();
          return Right(groupBooks);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
