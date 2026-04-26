import 'dart:math'; 
import 'package:example/provider/db/database_service.dart';
import 'package:example/screens/pagination/paginate.dart';
import 'package:example/screens/ressources/core/domaine/ressources_item_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivitysState {
  final RessourceItemPaged? activities;
  final bool isLastPage;

  ActivitysState({this.activities, this.isLastPage = false});
}

class ActivitysNotifier extends StateNotifier<ActivitysState> {
  final DatabaseService _databaseService;

  ActivitysNotifier(this._databaseService) : super(ActivitysState());

  int _currentPage = 0;
  final int _pageSize = 10;

  Future<void> fetchNextPage(String typeId, int page, {perPage}) async {
    var _data = await _databaseService.getActivities();

    final _filtered = _data
        .where((activity) => activity.type!.any((type) => type.id == typeId))
        .toList();

    final int _perPage = perPage ?? Paginate.DEFAULT_ITEM_PER_PAGE;
    final int _offset = (page - 1) * _perPage;
    final int _totalSize = (_filtered.length / _perPage).ceil();

    final data = RessourceItemPaged(
        page: page,
        data: _filtered
            .sublist(_offset, min(_offset + _perPage, _filtered.length))
            .map((e) => e)
            .toList(),
        hasNext: page < _totalSize,
        hasPrev: page > 1,
        perPage: _perPage,
        dataCount: _filtered.length,
        totalPages: _totalSize);
    if (_data.isEmpty) {
      state = ActivitysState(activities: state.activities, isLastPage: true);
    } else {
      state = ActivitysState(activities: data, isLastPage: false);
      _currentPage++;
    }
  }
}

final activityProvider =
    StateNotifierProvider<ActivitysNotifier, ActivitysState>((ref) {
  return ActivitysNotifier(DatabaseService());
});
