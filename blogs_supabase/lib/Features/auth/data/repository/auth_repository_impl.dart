import 'package:blogs_supabase/Features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blogs_supabase/core/common/entities/user.dart';
import 'package:blogs_supabase/core/error/exceptions.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/network/connection_checker.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.remoteDatasource, this.connectionChecker);
  @override
  Future<Either<Failure, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      final response = await remoteDatasource.signInWithEmailAndPassword(
          email: email, password: password);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      final response = await remoteDatasource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      if (await connectionChecker.isConnected) {
        final response = await remoteDatasource.getCurrentUser();
        if (response == null) {
          return left(Failure("User is  not logged in"));
        }
        return right(response);
      } else {
        final session = remoteDatasource.currentUserSession;
        if (session == null) {
          return left(Failure("No internet connection"));
        }
        return right(
            User(id: session.user.id, name: session.user.email!, email: ""));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
