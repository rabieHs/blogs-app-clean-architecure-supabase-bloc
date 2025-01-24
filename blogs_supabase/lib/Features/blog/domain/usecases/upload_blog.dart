// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';
import 'package:blogs_supabase/Features/blog/domain/repositories/blog_repository.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository repository;

  UploadBlog(this.repository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams parameter) async {
    return await repository.uploadBlog(
        image: parameter.image,
        title: parameter.title,
        content: parameter.content,
        posterId: parameter.posterId,
        topics: parameter.topics);
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;
  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
