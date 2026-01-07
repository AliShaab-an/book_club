import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/clubs/data/models/club_model.dart';
import 'package:client/features/clubs/domain/entities/club.dart';
import 'package:client/features/clubs/domain/repositories/clubs_repository.dart';
import 'package:fpdart/fpdart.dart';

class ClubsRepositoryImpl implements ClubsRepository {
  final HttpService httpService;
  final TokenManager tokenManager;

  ClubsRepositoryImpl({required this.httpService, required this.tokenManager});

  @override
  Future<Either<Failure, Club>> createClub({
    required String name,
    String? description,
    required String bookId,
  }) async {
    try {
      print(
        'DEBUG createClub: Starting club creation - name: $name, bookId: $bookId',
      );

      final token = await tokenManager.getToken();
      if (token == null) {
        print('DEBUG createClub: ERROR - No authentication token');
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      print('DEBUG createClub: Token found - ${token.substring(0, 20)}...');
      print('DEBUG createClub: Creating group via API...');
      // Create the group first
      final result = await httpService.post('/group/', {
        'name': name,
        'description': description,
      }, token: token);

      return result.fold(
        (failure) {
          print(
            'DEBUG createClub: ERROR - Failed to create group: ${failure.errMessage}',
          );
          return Left(failure);
        },
        (data) async {
          print('DEBUG createClub: Group created successfully - data: $data');
          final groupId = data['id']?.toString() ?? '';

          // Link the book to the group
          try {
            print(
              'DEBUG createClub: Linking book $bookId to group $groupId...',
            );
            final bookLinkResult = await httpService.post(
              '/group_book/select-book',
              {'group_id': groupId, 'book_id': bookId, 'status': 'not_started'},
              token: token,
            );

            bookLinkResult.fold(
              (failure) => print(
                'DEBUG createClub: WARNING - Failed to link book: ${failure.errMessage}',
              ),
              (bookData) => print(
                'DEBUG createClub: Book linked successfully - data: $bookData',
              ),
            );
          } catch (e) {
            print('DEBUG createClub: WARNING - Exception linking book: $e');
          }

          final club = ClubModel(
            id: groupId,
            name: data['name'] ?? name,
            bookId: bookId,
            bookTitle:
                null, // Will be populated when we fetch the club with book details
            bookCoverUrl: null,
            genre: 'General',
            membersCount: 1,
            unreadCount: 0,
            createdAt: data['created_at'] != null
                ? DateTime.parse(data['created_at'])
                : DateTime.now(),
          );

          print('DEBUG createClub: SUCCESS - Club created with ID: $groupId');
          return Right(club);
        },
      );
    } catch (e) {
      print('DEBUG createClub: EXCEPTION - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> getMyClubs() async {
    try {
      print('DEBUG getMyClubs: Fetching user groups...');

      final token = await tokenManager.getToken();
      if (token == null) {
        print('DEBUG getMyClubs: ERROR - No authentication token');
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      print('DEBUG getMyClubs: Token found - ${token.substring(0, 20)}...');

      final result = await httpService.get('/group/', token: token);

      return result.fold(
        (failure) {
          print('DEBUG getMyClubs: ERROR - ${failure.errMessage}');
          return Left(failure);
        },
        (data) {
          print('DEBUG getMyClubs: Response received - data: $data');

          // Handle both single object and list responses
          List<dynamic> groupsList;
          if (data.containsKey('data')) {
            groupsList = data['data'] as List? ?? [];
          } else {
            groupsList = [data];
          }

          print('DEBUG getMyClubs: Processing ${groupsList.length} groups');

          final clubs = groupsList.map((groupData) {
            // Parse the group data with book information
            return ClubModel(
              id: groupData['id']?.toString() ?? '',
              name: groupData['name'] ?? 'Unnamed Club',
              bookId: groupData['book_id']?.toString(),
              bookTitle: groupData['book_title']?.toString(),
              bookCoverUrl: groupData['book_cover_url']?.toString(),
              genre: 'General',
              membersCount: 1, // TODO: Get actual member count
              unreadCount: 0,
              createdAt: groupData['created_at'] != null
                  ? DateTime.parse(groupData['created_at'])
                  : DateTime.now(),
            );
          }).toList();

          print('DEBUG getMyClubs: SUCCESS - Returning ${clubs.length} clubs');
          return Right(clubs);
        },
      );
    } catch (e) {
      print('DEBUG getMyClubs: EXCEPTION - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> getDiscoverClubs() async {
    try {
      print('DEBUG getDiscoverClubs: Fetching all clubs...');

      final token = await tokenManager.getToken();
      if (token == null) {
        print('DEBUG getDiscoverClubs: ERROR - No authentication token');
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      // Use search endpoint with a wildcard to get all clubs
      final result = await httpService.get(
        '/group/search/all?query= ',
        token: token,
      );

      return result.fold(
        (failure) {
          print('DEBUG getDiscoverClubs: ERROR - ${failure.errMessage}');
          return Left(failure);
        },
        (data) {
          print('DEBUG getDiscoverClubs: Response received - data: $data');

          // Handle response - search endpoint returns array directly in data
          List<dynamic> groupsList;
          if (data.containsKey('data')) {
            groupsList = data['data'] as List? ?? [];
          } else {
            groupsList = [];
          }

          print(
            'DEBUG getDiscoverClubs: Processing ${groupsList.length} clubs',
          );

          final clubs = groupsList.map((groupData) {
            return ClubModel(
              id: groupData['id']?.toString() ?? '',
              name: groupData['name'] ?? 'Unnamed Club',
              bookId: null,
              bookTitle: null,
              bookCoverUrl: null,
              genre: 'General',
              membersCount: 1,
              unreadCount: 0,
              createdAt: groupData['created_at'] != null
                  ? DateTime.parse(groupData['created_at'])
                  : DateTime.now(),
            );
          }).toList();

          print(
            'DEBUG getDiscoverClubs: SUCCESS - Returning ${clubs.length} clubs',
          );
          return Right(clubs);
        },
      );
    } catch (e) {
      print('DEBUG getDiscoverClubs: EXCEPTION - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> searchClubs(String query) async {
    try {
      print('DEBUG searchClubs: Searching for "$query"...');

      final token = await tokenManager.getToken();
      if (token == null) {
        print('DEBUG searchClubs: ERROR - No authentication token');
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get(
        '/group/search/all?query=$query',
        token: token,
      );

      return result.fold(
        (failure) {
          print('DEBUG searchClubs: ERROR - ${failure.errMessage}');
          return Left(failure);
        },
        (data) {
          print('DEBUG searchClubs: Response received - data: $data');

          // HttpService wraps list response in {'data': list}
          List<dynamic> groupsList = data['data'] as List? ?? [];
          final clubs = groupsList.map((groupData) {
            return ClubModel(
              id: groupData['id']?.toString() ?? '',
              name: groupData['name'] ?? 'Unnamed Club',
              bookId: null,
              bookTitle: null,
              bookCoverUrl: null,
              genre: 'General',
              membersCount: 1,
              unreadCount: 0,
              createdAt: groupData['created_at'] != null
                  ? DateTime.parse(groupData['created_at'])
                  : DateTime.now(),
            );
          }).toList();

          print('DEBUG searchClubs: SUCCESS - Returning ${clubs.length} clubs');
          return Right(clubs);
        },
      );
    } catch (e) {
      print('DEBUG searchClubs: EXCEPTION - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Club>> getClubById(String clubId) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get('/group/$clubId', token: token);

      return result.fold((failure) => Left(failure), (data) {
        // TODO: Implement proper club mapping
        return Left(ServerFailure(message: 'Not implemented'));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinClub(String clubId) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.post(
        '/group/$clubId/join',
        {},
        token: token,
      );

      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
