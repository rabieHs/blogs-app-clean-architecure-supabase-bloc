import 'dart:io';

import 'package:blogs_supabase/Features/auth/domain/usecases/current_user.dart';
import 'package:blogs_supabase/Features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogs_supabase/Features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _getAllBlogs = getAllBlogs,
        _uploadBlog = uploadBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });

    on<BlogUpload>((event, emit) async {
      final response = await _uploadBlog(UploadBlogParams(
          posterId: event.posterId,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics));
      response.fold((l) => emit(BlogFailure(l.message)),
          (r) => emit(BlogUploadSuccess()));
    });

    on<BlogFetchAllBlogs>((event, emit) async {
      final response = await _getAllBlogs(NoParams());
      response.fold((l) => emit(BlogFailure(l.message)),
          (blogs) => emit(BlogDisplaySuccess(blogs: blogs)));
    });
  }
}
