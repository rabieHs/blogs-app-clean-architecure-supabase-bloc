// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogs_supabase/core/common/entities/user.dart';
import 'package:blogs_supabase/Features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements Usecase<User, UserSignUpParameters> {
  final AuthRepository repository;

  UserSignUp(this.repository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParameters parameter) async {
    return await repository.signUpWithEmailPassword(
        email: parameter.email,
        name: parameter.name,
        password: parameter.password);
  }
}

class UserSignUpParameters {
  final String name;
  final String email;
  final String password;
  UserSignUpParameters({
    required this.name,
    required this.email,
    required this.password,
  });
}
