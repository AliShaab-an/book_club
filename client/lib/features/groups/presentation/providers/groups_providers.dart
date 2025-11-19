import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/groups/data/repositories/groups_repository_impl.dart';
import 'package:client/features/groups/domain/entities/group.dart';
import 'package:client/features/groups/domain/repositories/groups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return GroupsRepositoryImpl(
    httpService: httpService,
    tokenManager: tokenManager,
  );
});

// Groups List Provider
final groupsListProvider = FutureProvider<List<Group>>((ref) async {
  final repository = ref.read(groupsRepositoryProvider);
  final result = await repository.getGroups();

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (groups) => groups,
  );
});

// Single Group Provider
final groupProvider = FutureProvider.family<Group, String>((
  ref,
  groupId,
) async {
  final repository = ref.read(groupsRepositoryProvider);
  final result = await repository.getGroupById(groupId);

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (group) => group,
  );
});
