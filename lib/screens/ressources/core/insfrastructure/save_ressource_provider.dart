import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/save_ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveRessourceNotifier extends StateNotifier<List<Ressources>?> {
  SaveRessourceNotifier(this.ref) : super(null) {
    repo = ref.read(favProvider);
    fetchSavedPlaylists();
  }

  late final SavedRessourceRepo repo;
  final StateNotifierProviderRef ref;

  void fetchSavedPlaylists() {
    state = repo.getFavoritelists();
  }

  void removeSavedPlaylist(String id) {
    state = repo.removeFavorite(id);
  }

  void addRessource(Ressources data) {
    state = repo.addFavorite(data);
  }

  void updateRessources(int index, Ressources data) {
    state = repo.updateFavorite(index, data);
  }

  ///remove todo from local Storage
  void removeTodo(String id) {
    state = repo.removeFavorite(id);
  }
}

final hiveProvider =
    StateNotifierProvider<SaveRessourceNotifier, List<Ressources>?>(
  (ref) => SaveRessourceNotifier(ref),
);

final getAllFavProvider = FutureProvider<List<Ressources>?>((ref) {
  final hiveData = ref.watch(hiveProvider);

  return hiveData ?? [];
});

final hiveExistProvider = StateNotifierProvider<ExistNotifier, bool?>(
  (ref) => ExistNotifier(ref),
);

class ExistNotifier extends StateNotifier<bool?> {
  ExistNotifier(this.ref) : super(null) {
    repo = ref.read(favProvider);
    init();
  }

  late final SavedRessourceRepo repo;
  final StateNotifierProviderRef ref;

  void addRessource(Ressources data) {
    state = repo.addFavorite(data).isNotEmpty;
  }

  ///remove todo from local Storage
  void removeTodo(String id) {
    state = repo.removeFavorite(id).isNotEmpty;
  }

  ///remove todo from local Storage
  void init() {
    repo.init();
  }
}
