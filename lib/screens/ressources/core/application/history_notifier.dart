import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'history_notifier.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const HistoryState._();
  const factory HistoryState.initial(List<Ressources>? result) = _Initial;
  const factory HistoryState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory HistoryState.loadSuccess(List<Ressources>? result) =
      _LoadSuccess;
  const factory HistoryState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  Future<RessourcesRepository> watch;

  HistoryNotifier(this.watch) : super(const HistoryState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '3'}) async {
    final _repository = await watch;
    state = const HistoryState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return HistoryState.loadFailure(state.result, failure: l);
    }, (r) {
      return HistoryState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '3', String searchItem = ''}) async {
    final _repository = await watch;
    state = HistoryState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return HistoryState.loadFailure(state.result, failure: l);
    }, (r) {
      return HistoryState.loadSuccess(r);
    });
  }
}
