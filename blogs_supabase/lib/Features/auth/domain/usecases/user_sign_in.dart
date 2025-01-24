// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogs_supabase/core/common/entities/user.dart';
import 'package:blogs_supabase/Features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UserSignIn implements Usecase<User, UserSignInParams> {
  final AuthRepository repository;
  UserSignIn({
    required this.repository,
  });
  @override
  Future<Either<Failure, User>> call(UserSignInParams parameter) async {
    return await repository.logInWithEmailPassword(
        email: parameter.email, password: parameter.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
