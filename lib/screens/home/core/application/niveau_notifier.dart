import 'package:example/screens/home/core/insfrastructure/niveau_repository.dart';
import 'package:example/screens/ressources/core/application/fiche_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NiveauNotifier extends StateNotifier<FichesState> {
  Future<NiveauRepository> watch;

  NiveauNotifier(this.watch) : super(const FichesState.initial(null));

  Future<void> fetchRessource(
      {bool local = true, String typeId = '1', String niveau = ''}) async {
    final repository = await watch;
    state = const FichesState.loadInProgress([]);
    Future.delayed(const Duration(seconds: 2));
    final failureOrSuccess = await repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return FichesState.loadFailure(state.result, failure: l);
    }, (r) {
      return FichesState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true,
      String typeId = '1',
      String searchItem = '',
      String niveau = ''}) async {
    final repository = await watch;
    state = FichesState.loadInProgress(state.result);
    final failureOrSuccess = await repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return FichesState.loadFailure(state.result, failure: l);
    }, (r) {
      return FichesState.loadSuccess(r);
    });
  }
}
