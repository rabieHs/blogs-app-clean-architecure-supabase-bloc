import 'package:blogs_supabase/Features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blogs_supabase/Features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogs_supabase/Features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogs_supabase/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_supabase/Features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blogs_supabase/Features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blogs_supabase/Features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blogs_supabase/Features/blog/domain/repositories/blog_repository.dart';
import 'package:blogs_supabase/Features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogs_supabase/Features/blog/domain/usecases/upload_blog.dart';
import 'package:blogs_supabase/Features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_supabase/core/network/connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Features/auth/domain/usecases/current_user.dart';
import 'core/secrets/app_secrets.dart';

part 'init_dependencies.main.dart';
