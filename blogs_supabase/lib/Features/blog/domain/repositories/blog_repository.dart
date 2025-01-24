import 'dart:io';

import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics});

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
