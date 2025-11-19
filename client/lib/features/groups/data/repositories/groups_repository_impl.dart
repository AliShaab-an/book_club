import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/groups/data/models/group_model.dart';
import 'package:client/features/groups/domain/entities/group.dart' as entities;
import 'package:client/features/groups/domain/repositories/groups_repository.dart';
import 'package:fpdart/fpdart.dart' hide Group;

class GroupsRepositoryImpl implements GroupsRepository {
  final HttpService httpService;
  final TokenManager tokenManager;

  GroupsRepositoryImpl({required this.httpService, required this.tokenManager});

  @override
  Future<Either<Failure, entities.Group>> createGroup({
    required String name,
    String? description,
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.post('/group/', {
        'name': name,
        'description': description,
      }, token: token);

      return result.fold((failure) => Left(failure), (data) {
        final group = GroupModel.fromMap(data);
        return Right(group);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entities.Group>>> getGroups() async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get('/group/', token: token);

      return result.fold((failure) => Left(failure), (data) {
        final List<dynamic> groupsJson = data as List<dynamic>;
        final groups = groupsJson
            .map((json) => GroupModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return Right(groups);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Group>> getGroupById(String groupId) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get('/group/$groupId', token: token);

      return result.fold((failure) => Left(failure), (data) {
        final group = GroupModel.fromMap(data);
        return Right(group);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Group>> updateGroup({
    required String groupId,
    required String name,
    String? description,
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.put('/group/$groupId', {
        'name': name,
        'description': description,
      }, token: token);

      return result.fold((failure) => Left(failure), (data) {
        final group = GroupModel.fromMap(data);
        return Right(group);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.delete('/group/$groupId', token: token);

      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
