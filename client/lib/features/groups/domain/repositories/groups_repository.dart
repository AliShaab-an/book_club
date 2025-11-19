import 'package:client/core/errors/failure.dart';
import 'package:client/features/groups/domain/entities/group.dart' as entities;
import 'package:fpdart/fpdart.dart';

abstract class GroupsRepository {
  Future<Either<Failure, entities.Group>> createGroup({
    required String name,
    String? description,
  });

  Future<Either<Failure, List<entities.Group>>> getGroups();

  Future<Either<Failure, entities.Group>> getGroupById(String groupId);

  Future<Either<Failure, entities.Group>> updateGroup({
    required String groupId,
    required String name,
    String? description,
  });

  Future<Either<Failure, void>> deleteGroup(String groupId);
}
