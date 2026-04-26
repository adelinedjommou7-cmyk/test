import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'fiche_notifier.freezed.dart';

@freezed
class FichesState with _$FichesState {
  const FichesState._();
  const factory FichesState.initial(List<Ressources>? result) = _Initial;
  const factory FichesState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory FichesState.loadSuccess(List<Ressources>? result) =
      _LoadSuccess;
  const factory FichesState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class FichesNotifier extends StateNotifier<FichesState> {
  Future<RessourcesRepository> watch;

  FichesNotifier(this.watch) : super(const FichesState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '1'}) async {
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
