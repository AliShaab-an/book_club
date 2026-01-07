import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/clubs/data/repositories/clubs_repository_impl.dart';
import 'package:client/features/clubs/domain/entities/club.dart';
import 'package:client/features/clubs/domain/repositories/clubs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final clubsRepositoryProvider = Provider<ClubsRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return ClubsRepositoryImpl(
    httpService: httpService,
    tokenManager: tokenManager,
  );
});

// Create Club Provider
final createClubProvider = FutureProvider.family<Club, Map<String, String>>((
  ref,
  clubData,
) async {
  final repository = ref.read(clubsRepositoryProvider);
  final result = await repository.createClub(
    name: clubData['name']!,
    description: clubData['description'],
    bookId: clubData['bookId']!,
  );

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (club) => club,
  );
});

// My Clubs Provider
final myClubsProvider = FutureProvider<List<Club>>((ref) async {
  final repository = ref.read(clubsRepositoryProvider);
  final result = await repository.getMyClubs();

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (clubs) => clubs,
  );
});

// Discover Clubs Provider
final discoverClubsProvider = FutureProvider<List<Club>>((ref) async {
  final repository = ref.read(clubsRepositoryProvider);
  final result = await repository.getDiscoverClubs();

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (clubs) => clubs,
  );
});

// Search Clubs Provider
final searchClubsProvider = FutureProvider.family<List<Club>, String>((
  ref,
  query,
) async {
  final repository = ref.read(clubsRepositoryProvider);
  final result = await repository.searchClubs(query);

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (clubs) => clubs,
  );
});

// Join Club Provider
final joinClubProvider = FutureProvider.family<void, String>((
  ref,
  clubId,
) async {
  final repository = ref.read(clubsRepositoryProvider);
  final result = await repository.joinClub(clubId);

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (_) => null,
  );
});
