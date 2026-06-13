import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/rapport_genere.dart';
import '../../domain/repositories/rapports_repository.dart';
import '../rapports_service.dart';

class RapportsRepositoryImpl implements RapportsRepository {
  final RapportsService _service;
  RapportsRepositoryImpl(this._service);

  @override
  Future<Either<Failure, RapportGenere>> genererCra(ParamsRapportCra params) async {
    try {
      final bytes = await _service.genererCra(
        uniteId: params.uniteId,
        debut:   params.debut,
        fin:     params.fin,
      );
      final nom = 'CRA_${DateFormat('yyyy_MM').format(params.debut)}.pdf';
      return Right(RapportGenere(bytes: bytes, nom: nom));
    } catch (e) {
      return Left(Failure.serveur(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RapportGenere>> genererFinancier(
      ParamsRapportFinancier params) async {
    try {
      final bytes = await _service.genererFinancier(
        uniteId: params.uniteId,
        debut:   params.debut,
        fin:     params.fin,
      );
      final nom = 'Financier_${DateFormat('yyyy_MM').format(params.debut)}.pdf';
      return Right(RapportGenere(bytes: bytes, nom: nom));
    } catch (e) {
      return Left(Failure.serveur(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RapportGenere>> genererReunion(
      ParamsRapportReunion params) async {
    try {
      final bytes = await _service.genererReunion(reunionId: params.reunionId);
      final titre = params.titre.replaceAll(' ', '_');
      final nom   = 'Reunion_${titre.substring(0, titre.length.clamp(0, 20))}.pdf';
      return Right(RapportGenere(bytes: bytes, nom: nom));
    } catch (e) {
      return Left(Failure.serveur(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RapportGenere>> genererEvenement(
      ParamsRapportEvenement params) async {
    try {
      final bytes = await _service.genererEvenement(evenementId: params.evenementId);
      final titre = params.titre.replaceAll(' ', '_');
      final nom   = 'Evenement_${titre.substring(0, titre.length.clamp(0, 20))}.pdf';
      return Right(RapportGenere(bytes: bytes, nom: nom));
    } catch (e) {
      return Left(Failure.serveur(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RapportGenere>> genererCotisations(
      ParamsRapportCotisations params) async {
    try {
      final bytes = await _service.genererCotisations(
        uniteId: params.uniteId,
        annee:   params.annee,
        mois:    params.mois,
      );
      final nom = 'Cotisations_${params.annee}_${params.mois.toString().padLeft(2, '0')}.pdf';
      return Right(RapportGenere(bytes: bytes, nom: nom));
    } catch (e) {
      return Left(Failure.serveur(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RapportGenere>> genererActivite(
      ParamsRapportActivite params) async {
    try {
      final bytes = await _service.genererRapportActivite(
        uniteId:          params.uniteId,
        debut:            params.debut,
        fin:              params.fin,
        inclureMilitants: params.inclureMilitants,
        inclureProspects: params.inclureProspects,
        inclureFinances:  params.inclureFinances,
        inclureEvenements: params.inclureEvenements,
        inclureReunions:  params.inclureReunions,
        inclureBureau:    params.inclureBureau,
      );
      final fmt = DateFormat('yyyy_MM');
      final nom = 'RapportActivite_${fmt.format(params.debut)}_${fmt.format(params.fin)}.pdf';
      return Right(RapportGenere(bytes: bytes, nom: nom));
    } catch (e) {
      return Left(Failure.serveur(message: e.toString()));
    }
  }
}