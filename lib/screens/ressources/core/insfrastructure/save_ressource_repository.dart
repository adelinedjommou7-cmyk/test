import 'package:example/models/ressources.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class SavedRessourceRepo {
  late Box<Ressources> _hive;
  late List<Ressources> _box;

  SavedRessourceRepo();

  init() {
    _hive = Hive.box<Ressources>('todos');
  }

  List<Ressources> getFavoritelists() {
    /// Fetch the Todos from the "todos" database
    _hive = Hive.box<Ressources>('todos');
    _box = _hive.values.toList();
    return _box;
  }

  /// Add Todo to Database
  List<Ressources> addFavorite(Ressources todo) {
    // _hive = Hive.box<Ressources>('todos');

    _hive.add(todo);
    return _hive.values.toList();
  }

  /// Remove Particular Todo by id
  List<Ressources> removeFavorite(String id) {
    // _hive = Hive.box<Ressources>('todos');
    _hive.deleteAt(
        _hive.values.toList().indexWhere((element) => element.id == id));
    return _hive.values.toList();
  }

  /// Remove Particular Todo by id
  bool existFavorite(String id) {
    _hive = Hive.box<Ressources>('todos');

    _hive.get(_hive.values.toList().indexWhere((element) => element.id == id));
    return _hive.isNotEmpty;
  }

  /// Update Todo
  List<Ressources> updateFavorite(int index, Ressources todo) {
    _hive.putAt(index, todo);
    return _hive.values.toList();
  }

  /// Delete All Todo in Database
  void deleteAll() {
    _box.clear();
  }
}

final favProvider = Provider<SavedRessourceRepo>((ref) => SavedRessourceRepo());
