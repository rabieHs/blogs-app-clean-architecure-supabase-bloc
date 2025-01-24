import 'dart:io';

import 'package:blogs_supabase/Features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blogs_supabase/Features/blog/data/models/blog_model.dart';
import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';
import 'package:blogs_supabase/Features/blog/domain/repositories/blog_repository.dart';
import 'package:blogs_supabase/core/error/exceptions.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource blogRemoteDatasource;

  BlogRepositoryImpl(this.blogRemoteDatasource);
  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      BlogModel blogModel = BlogModel(
          id: Uuid().v1(),
          poserId: posterId,
          title: title,
          content: content,
          imageUrl: "",
          topics: topics,
          updatedAt: DateTime.now());

      final imageUrl = await blogRemoteDatasource.uploadBlogImage(
          image: image, blog: blogModel);
      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final updatedBlog = await blogRemoteDatasource.uploadBlog(blogModel);
      return right(updatedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDatasource.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
