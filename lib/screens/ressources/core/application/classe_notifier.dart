import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'classe_notifier.freezed.dart';

@freezed
class ClasseState with _$ClasseState {
  const ClasseState._();
  const factory ClasseState.initial(List<Ressources>? result) = _Initial;
  const factory ClasseState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory ClasseState.loadSuccess(List<Ressources>? result) =
      _LoadSuccess;
  const factory ClasseState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class ClasseNotifier extends StateNotifier<ClasseState> {
  Future<RessourcesRepository> watch;

  ClasseNotifier(this.watch) : super(const ClasseState.initial(null));

  Future<void> fetchRessource({bool local = true, String typeId = '4'}) async {
    final _repository = await watch;
    state = const ClasseState.loadInProgress([]);
    Future.delayed(Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return ClasseState.loadFailure(state.result, failure: l);
    }, (r) {
      return ClasseState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '4', String searchItem = ''}) async {
    final _repository = await watch;
    state = ClasseState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return ClasseState.loadFailure(state.result, failure: l);
    }, (r) {
      return ClasseState.loadSuccess(r);
    });
  }
}
