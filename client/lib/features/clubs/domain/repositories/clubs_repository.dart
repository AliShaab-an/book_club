import 'package:client/core/errors/failure.dart';
import 'package:client/features/clubs/domain/entities/club.dart';
import 'package:fpdart/fpdart.dart';

abstract class ClubsRepository {
  Future<Either<Failure, Club>> createClub({
    required String name,
    String? description,
    required String bookId,
  });

  Future<Either<Failure, List<Club>>> getMyClubs();

  Future<Either<Failure, List<Club>>> getDiscoverClubs();

  Future<Either<Failure, List<Club>>> searchClubs(String query);

  Future<Either<Failure, Club>> getClubById(String clubId);

  Future<Either<Failure, void>> joinClub(String clubId);
}
