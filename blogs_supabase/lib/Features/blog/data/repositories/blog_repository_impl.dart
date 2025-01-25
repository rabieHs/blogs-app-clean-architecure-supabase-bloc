import 'dart:io';

import 'package:blogs_supabase/Features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blogs_supabase/Features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blogs_supabase/Features/blog/data/models/blog_model.dart';
import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';
import 'package:blogs_supabase/Features/blog/domain/repositories/blog_repository.dart';
import 'package:blogs_supabase/core/error/exceptions.dart';
import 'package:blogs_supabase/core/error/failure.dart';
import 'package:blogs_supabase/core/network/connection_checker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource blogRemoteDatasource;
  final BlogLocalDatasource blogLocalDatasource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDatasource, this.blogLocalDatasource,
      this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
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
      if (!await connectionChecker.isConnected) {
        final blogs = blogLocalDatasource.getCachedBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDatasource.getAllBlogs();
      blogLocalDatasource.cacheBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
