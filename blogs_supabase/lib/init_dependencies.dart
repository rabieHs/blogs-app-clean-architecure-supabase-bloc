import 'package:blogs_supabase/Features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blogs_supabase/Features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogs_supabase/Features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogs_supabase/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_supabase/Features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blogs_supabase/Features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blogs_supabase/Features/blog/domain/repositories/blog_repository.dart';
import 'package:blogs_supabase/Features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogs_supabase/Features/blog/domain/usecases/upload_blog.dart';
import 'package:blogs_supabase/Features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Features/auth/domain/usecases/current_user.dart';
import 'core/secrets/app_secrets.dart';

final sl = GetIt.instance;
Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseKey);

  sl.registerLazySingleton(() => supabase.client);

  //core
  sl.registerLazySingleton(() => AppUserCubit());
  _initAuth();
  _initBlog();
}

//core

void _initAuth() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<UserSignUp>(() => UserSignUp(sl()));
  sl.registerLazySingleton<UserSignIn>(() => UserSignIn(repository: sl()));
  sl.registerLazySingleton<CurrentUser>(() => CurrentUser(repository: sl()));

  sl.registerFactory<AuthBloc>(() => AuthBloc(
      userSignUp: sl(),
      userSignIn: sl(),
      currentUser: sl(),
      appUserCubit: sl()));
}

void _initBlog() {
  sl.registerLazySingleton<BlogRemoteDatasource>(
      () => BlogRemoteDatasourceImpl(supabaseClient: sl()));

  sl.registerLazySingleton<BlogRepository>(() => BlogRepositoryImpl(sl()));

  sl.registerLazySingleton<UploadBlog>(() => UploadBlog(sl()));
  sl.registerLazySingleton<GetAllBlogs>(() => GetAllBlogs(sl()));

  sl.registerFactory<BlogBloc>(
      () => BlogBloc(uploadBlog: sl(), getAllBlogs: sl()));
}
