import 'package:blogs_supabase/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<T,P> {
  Future<Either<Failure,T>>call(P parameter);
}