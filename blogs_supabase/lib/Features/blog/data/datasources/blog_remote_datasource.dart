// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:blogs_supabase/Features/blog/data/models/blog_model.dart';
import 'package:blogs_supabase/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDatasource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog});

  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDatasourceImpl implements BlogRemoteDatasource {
  final SupabaseClient supabaseClient;
  BlogRemoteDatasourceImpl({
    required this.supabaseClient,
  });
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from("blogs").insert(blog.toMap()).select();
      return BlogModel.fromMap(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog}) async {
    try {
      await supabaseClient.storage.from("blog_images").upload(blog.id, image);
      return supabaseClient.storage.from("blog_images").getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final result =
          await supabaseClient.from("blogs").select("*,profiles (name)");
      return result
          .map((blog) => BlogModel.fromMap(blog)
              .copyWith(posterName: blog["profile"]["name"]))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
