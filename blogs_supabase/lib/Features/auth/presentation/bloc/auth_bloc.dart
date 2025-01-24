import 'package:blogs_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_supabase/core/common/entities/user.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/current_user.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_supabase/Features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserSignIn userSignIn,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<AuthSignUp>((event, emit) async {
      final result = await _userSignUp(UserSignUpParameters(
          name: event.name, email: event.email, password: event.password));

      result.fold((l) => emit(AuthFailure(l.message)), (r) {
        _appUserCubit.updateUser(r);
        emit(AuthSuccess(r));
      });
    });

    on<AuthLogin>((event, emit) async {
      final result = await _userSignIn(
          UserSignInParams(email: event.email, password: event.password));
      result.fold((l) => emit(AuthFailure(l.message)), (r) {
        _appUserCubit.updateUser(r);
        emit(AuthSuccess(r));
      });
    });

    on<AuthCurrentUser>((event, emit) async {
      final result = await _currentUser(NoParams());
      result.fold((l) => emit(AuthFailure(l.message)), (r) {
        _appUserCubit.updateUser(r);
        emit(AuthSuccess(r));
      });
    });
  }
}
