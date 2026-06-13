import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/rapport_genere.dart';
import '../repositories/rapports_repository.dart';

class GenererRapportCra implements UseCase<RapportGenere, ParamsRapportCra> {
  final RapportsRepository repository;
  GenererRapportCra(this.repository);

  @override
  Future<Either<Failure, RapportGenere>> call(ParamsRapportCra params) =>
      repository.genererCra(params);
}

class GenererRapportFinancier
    implements UseCase<RapportGenere, ParamsRapportFinancier> {
  final RapportsRepository repository;
  GenererRapportFinancier(this.repository);

  @override
  Future<Either<Failure, RapportGenere>> call(ParamsRapportFinancier params) =>
      repository.genererFinancier(params);
}

class GenererRapportReunion
    implements UseCase<RapportGenere, ParamsRapportReunion> {
  final RapportsRepository repository;
  GenererRapportReunion(this.repository);

  @override
  Future<Either<Failure, RapportGenere>> call(ParamsRapportReunion params) =>
      repository.genererReunion(params);
}

class GenererRapportEvenement
    implements UseCase<RapportGenere, ParamsRapportEvenement> {
  final RapportsRepository repository;
  GenererRapportEvenement(this.repository);

  @override
  Future<Either<Failure, RapportGenere>> call(ParamsRapportEvenement params) =>
      repository.genererEvenement(params);
}

class GenererRapportCotisations
    implements UseCase<RapportGenere, ParamsRapportCotisations> {
  final RapportsRepository repository;
  GenererRapportCotisations(this.repository);

  @override
  Future<Either<Failure, RapportGenere>> call(ParamsRapportCotisations params) =>
      repository.genererCotisations(params);
}

class GenererRapportActivite
    implements UseCase<RapportGenere, ParamsRapportActivite> {
  final RapportsRepository repository;
  GenererRapportActivite(this.repository);

  @override
  Future<Either<Failure, RapportGenere>> call(ParamsRapportActivite params) =>
      repository.genererActivite(params);
}