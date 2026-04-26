import 'package:example/screens/ressources/core/application/fiche_notifier.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivitiesNotifier extends StateNotifier<FichesState> {
  Future<RessourcesRepository> watch;

  ActivitiesNotifier(this.watch) : super(const FichesState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '1', String niveau = '1'}) async {
    final _repository = await watch;
    state = const FichesState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return FichesState.loadFailure(state.result, failure: l);
    }, (r) {
      return FichesState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '1', String searchItem = ''}) async {
    final _repository = await watch;
    state = FichesState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return FichesState.loadFailure(state.result, failure: l);
    }, (r) {
      return FichesState.loadSuccess(r);
    });
  }
}
