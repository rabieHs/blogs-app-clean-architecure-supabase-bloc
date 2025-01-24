// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogs_supabase/Features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository repository;
  CurrentUser({
    required this.repository,
  });
  @override
  Future<Either<Failure, User>> call(NoParams parameter) async {
    return await repository.getCurrentUser();
  }
}

class NoParams {}
