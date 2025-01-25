part of 'init_dependencies.dart';

final sl = GetIt.instance;
Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseKey);
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  sl.registerLazySingleton(() => supabase.client);

  final checker = InternetConnection();

  sl.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(checker: checker));

  sl.registerLazySingleton(() => Hive.box(name: "blogs"));

  //core
  sl.registerLazySingleton(() => AppUserCubit());

  _initAuth();
  _initBlog();
}

//core

void _initAuth() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

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
  sl.registerLazySingleton<BlogLocalDatasource>(
      () => BlogLocalDatasourceImpl(box: sl()));

  sl.registerLazySingleton<BlogRepository>(
      () => BlogRepositoryImpl(sl(), sl(), sl()));

  sl.registerLazySingleton<UploadBlog>(() => UploadBlog(sl()));
  sl.registerLazySingleton<GetAllBlogs>(() => GetAllBlogs(sl()));

  sl.registerFactory<BlogBloc>(
      () => BlogBloc(uploadBlog: sl(), getAllBlogs: sl()));
}
