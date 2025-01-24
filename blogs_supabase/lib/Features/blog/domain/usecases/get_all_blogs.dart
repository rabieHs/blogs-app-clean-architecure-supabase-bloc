import 'package:blogs_supabase/Features/auth/domain/usecases/current_user.dart';
import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';
import 'package:blogs_supabase/Features/blog/domain/repositories/blog_repository.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
  final BlogRepository repository;

  GetAllBlogs(this.repository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams parameter) async {
    return await repository.getAllBlogs();
  }
}
