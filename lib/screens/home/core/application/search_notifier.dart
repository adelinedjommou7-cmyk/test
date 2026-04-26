import 'package:example/screens/ressources/core/application/fiche_notifier.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends StateNotifier<FichesState> {
  Future<RessourcesRepository> watch;

  SearchNotifier(this.watch) : super(const FichesState.initial(null));

  Future<void> fetchRessource(
      {bool local = true, String typeId = '', String niveau = ''}) async {
    final repository = await watch;
    state = const FichesState.loadInProgress([]);
    Future.delayed(const Duration(seconds: 2));
    final failureOrSuccess = await repository.fetchAllRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return FichesState.loadFailure(state.result, failure: l);
    }, (r) {
      return FichesState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true,
      String typeId = '',
      String searchItem = '',
      String niveau = ''}) async {
    final repository = await watch;
    state = FichesState.loadInProgress(state.result);
    final failureOrSuccess = await repository.searchAllRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return FichesState.loadFailure(state.result, failure: l);
    }, (r) {
      return FichesState.loadSuccess(r);
    });
  }
}
