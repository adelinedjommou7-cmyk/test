import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'bank_notifier.freezed.dart';

@freezed
class BankState with _$BankState {
  const BankState._();
  const factory BankState.initial(List<Ressources>? result) = _Initial;
  const factory BankState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory BankState.loadSuccess(List<Ressources>? result) = _LoadSuccess;
  const factory BankState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class BankNotifier extends StateNotifier<BankState> {
  Future<RessourcesRepository> watch;

  BankNotifier(this.watch) : super(const BankState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '2'}) async {
    final _repository = await watch;
    state = const BankState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return BankState.loadFailure(state.result, failure: l);
    }, (r) {
      return BankState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '2', String searchItem = ''}) async {
    final _repository = await watch;
    state = BankState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return BankState.loadFailure(state.result, failure: l);
    }, (r) {
      return BankState.loadSuccess(r);
    });
  }
}
