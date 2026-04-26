import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';
part 'ressource_notifier.freezed.dart';

@freezed
class RessourceState with _$RessourceState {
  const RessourceState._();
  const factory RessourceState.initial(List<Ressources>? result) = _Initial;
  const factory RessourceState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory RessourceState.loadSuccess(List<Ressources>? result) =
      _LoadSuccess;
  const factory RessourceState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class RessourceNotifier extends StateNotifier<RessourceState> {
  Future<RessourcesRepository> watch;

  RessourceNotifier(this.watch) : super(const RessourceState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '6'}) async {
    final _repository = await watch;
    state = const RessourceState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return RessourceState.loadFailure(state.result, failure: l);
    }, (r) {
      return RessourceState.loadSuccess(r);
    });
  }

  Future<void> fetchHistorique({bool local = true, String typeId = '3'}) async {
    final _repository = await watch;
    state = const RessourceState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return RessourceState.loadFailure(state.result, failure: l);
    }, (r) {
      return RessourceState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '6', String searchItem = ''}) async {
    final _repository = await watch;
    state = RessourceState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return RessourceState.loadFailure(state.result, failure: l);
    }, (r) {
      return RessourceState.loadSuccess(r);
    });
  }
}
