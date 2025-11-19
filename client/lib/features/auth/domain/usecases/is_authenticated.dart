import 'package:client/features/auth/domain/repositories/auth_repository.dart';

class IsAuthenticated {
  final AuthRepository repository;

  IsAuthenticated(this.repository);

  Future<bool> call() {
    return repository.isAuthenticated();
  }
}
