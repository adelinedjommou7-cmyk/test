import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'online_notifier.freezed.dart';

@freezed
class OnlineState with _$OnlineState {
  const OnlineState._();
  const factory OnlineState.initial(List<Ressources>? result) = _Initial;
  const factory OnlineState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory OnlineState.loadSuccess(List<Ressources>? result) =
      _LoadSuccess;
  const factory OnlineState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class OnlineNotifier extends StateNotifier<OnlineState> {
  Future<RessourcesRepository> watch;

  OnlineNotifier(this.watch) : super(const OnlineState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '5'}) async {
    final _repository = await watch;
    state = const OnlineState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return OnlineState.loadFailure(state.result, failure: l);
    }, (r) {
      return OnlineState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '5', String searchItem = ''}) async {
    final _repository = await watch;
    state = OnlineState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return OnlineState.loadFailure(state.result, failure: l);
    }, (r) {
      return OnlineState.loadSuccess(r);
    });
  }
}
