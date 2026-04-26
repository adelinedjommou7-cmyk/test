import 'package:dartz/dartz.dart';
import 'package:example/models/ressources.dart';

class NiveauRepository {
  final List<Ressources> _localService;

  NiveauRepository(this._localService);

  Future<Either<String, List<Ressources>?>> fetchRessource(
      {bool local = true, String typeId = '1'}) async {
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

  Future<Either<String, List<Ressources>?>> searchRessource(
      {bool local = true, String typeId = '6', String searchItem = ''}) async {
    if (local) {
      final List<Ressources> user = _localService
          .where((activity) => activity.type!.any((type) => type.id == typeId))
          .toList();

      final displayElements = user.where((activity) {
        final searchLower = searchItem.toLowerCase();
        final data = activity.title!.toLowerCase().contains(searchLower);
        return data;
      }).toList();

      return right(displayElements);
    } else {
      final List<Ressources> user = _localService
          .where((activity) => activity.type!.any((type) => type.id == typeId))
          .toList();

      final displayElements = user.where((activity) {
        final searchLower = searchItem.toLowerCase();
        final data = activity.title!.toLowerCase().contains(searchLower);
        return data;
      }).toList();

      return right(displayElements);
    }
  }
}
