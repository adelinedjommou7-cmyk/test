import 'package:example/models/ressources.dart';
import 'package:example/screens/ressources/core/insfrastructure/activities_repository.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'class_activities_notifier.freezed.dart';

@freezed
class ClasseActivitiesState with _$ClasseActivitiesState {
  const ClasseActivitiesState._();
  const factory ClasseActivitiesState.initial(List<Ressources>? result) =
      _Initial;
  const factory ClasseActivitiesState.loadInProgress(List<Ressources>? result) =
      _LoadInProgress;
  const factory ClasseActivitiesState.loadSuccess(List<Ressources>? result) =
      _LoadSuccess;
  const factory ClasseActivitiesState.loadFailure(List<Ressources>? result,
      {required String failure}) = _loadFailure;
}

class ClasseActivitiesNotifier extends StateNotifier<ClasseActivitiesState> {
  Future<ActivitiesRepository> watch;

  ClasseActivitiesNotifier(this.watch)
      : super(const ClasseActivitiesState.initial(null));

  Future<void> fetchRessource({bool local = true, String niveau = '1'}) async {
    final _repository = await watch;
    state = const ClasseActivitiesState.loadInProgress([]);
    Future.delayed(const Duration(seconds: 2));
    final failureOrSuccess = await _repository.fetchRessource(niveau: niveau);
    state = failureOrSuccess.fold((l) {
      return ClasseActivitiesState.loadFailure(state.result, failure: l);
    }, (r) {
      return ClasseActivitiesState.loadSuccess(r);
    });
  }

  Future<void> searchRessource(
      {bool local = true, String typeId = '1', String searchItem = ''}) async {
    final _repository = await watch;
    state = ClasseActivitiesState.loadInProgress(state.result);
    final failureOrSuccess = await _repository.searchRessource(
        searchItem: searchItem, typeId: typeId);
    state = failureOrSuccess.fold((l) {
      return ClasseActivitiesState.loadFailure(state.result, failure: l);
    }, (r) {
      return ClasseActivitiesState.loadSuccess(r);
    });
  }
}
