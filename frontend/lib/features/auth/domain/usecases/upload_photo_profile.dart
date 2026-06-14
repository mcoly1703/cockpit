import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

export '../repositories/auth_repository.dart' show ParamsUploaderPhoto;

class UploaderPhotoProfile implements UseCase<String, ParamsUploaderPhoto> {
  final AuthRepository repository;
  UploaderPhotoProfile(this.repository);

  @override
  Future<Either<Failure, String>> call(ParamsUploaderPhoto params) =>
      repository.uploaderPhoto(params);
}