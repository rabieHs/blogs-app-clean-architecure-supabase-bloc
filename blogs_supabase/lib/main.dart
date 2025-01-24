import 'package:blogs_supabase/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_supabase/Features/auth/presentation/pages/login.dart';
import 'package:blogs_supabase/Features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_supabase/Features/blog/presentation/pages/blog_page.dart';
import 'package:blogs_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_supabase/core/theme/theme.dart';
import 'package:blogs_supabase/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => sl<AppUserCubit>()),
      BlocProvider(create: (context) => sl<AuthBloc>()),
      BlocProvider(create: (context) => sl<BlogBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthCurrentUser());
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return BlogPage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
