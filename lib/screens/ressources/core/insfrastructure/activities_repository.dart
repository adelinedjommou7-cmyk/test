import 'package:dartz/dartz.dart';
import 'package:example/models/ressources.dart';
import 'package:example/widgets/helper.dart';

class ActivitiesRepository {
  final List<Ressources> _localService;

  ActivitiesRepository(this._localService);

  Future<Either<String, List<Ressources>?>> fetchRessource(
      {bool local = true, String niveau = '1'}) async {
    if (local) {
      final List<Ressources> user = _localService
          .where((activity) => activity.niveau!.any((type) => type == niveau))
          .toList();
      return right(user);
    } else {
      final List<Ressources> user = _localService
          .where((activity) => activity.niveau!.any((type) => type == niveau))
          .toList();
      return right(user);
    }
  }

  Future<Either<String, List<Ressources>?>> searchRessource(
      {bool local = true,
      String typeId = '6',
      String searchItem = '',
      String niveau = ''}) async {
    if (local) {
      List<Ressources>? niveauList;
      final List<Ressources> user = _localService
          .where((activity) => activity.type!.any((type) => type.id == typeId))
          .toList();

      if (niveau.isNotEmpty) {
        niveauList = user
            .where((activity) => activity.niveau!.any((type) => type == niveau))
            .toList();

        final displayElements = niveauList.where((activity) {
          final searchLower = removeDiacritics(searchItem.toLowerCase());
          final data = removeDiacritics(activity.title!.toLowerCase())
              .contains(searchLower);
          return data;
        }).toList();

        return right(displayElements);
      } else {
        final displayElements = user.where((activity) {
          final searchLower = removeDiacritics(searchItem.toLowerCase());
          final data = removeDiacritics(activity.title!.toLowerCase())
              .contains(searchLower);
          return data;
        }).toList();
        return right(displayElements);
      }
    } else {
      List<Ressources>? niveauList;
      final List<Ressources> user = _localService
          .where((activity) => activity.type!.any((type) => type.id == typeId))
          .toList();

      if (niveau.isNotEmpty) {
        niveauList = user
            .where((activity) => activity.niveau!.any((type) => type == niveau))
            .toList();

        final displayElements = niveauList.where((activity) {
          final searchLower = removeDiacritics(searchItem.toLowerCase());
          final data = removeDiacritics(activity.title!.toLowerCase())
              .contains(searchLower);
          return data;
        }).toList();

        return right(displayElements);
      } else {
        final displayElements = user.where((activity) {
          final searchLower = removeDiacritics(searchItem.toLowerCase());
          final data = removeDiacritics(activity.title!.toLowerCase())
              .contains(searchLower);
          return data;
        }).toList();
        return right(displayElements);
      }
    }
  }

  Future<Either<String, List<Ressources>?>> fetchRessourcePaginate(
      {bool local = true, String typeId = '6'}) async {
    if (local) {
      final List<Ressources> user = _localService
          .where((activity) => activity.type!.any((type) => type.id == typeId))
          .toList();
      return right(user);
    } else {
      final List<Ressources> user = _localService
          .where((activity) => activity.type!.any((type) => type.id == typeId))
          .toList();
      return right(user);
    }
  }
}
