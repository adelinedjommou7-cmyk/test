import 'dart:math';

import 'package:example/models/ressources.dart';
import 'package:example/provider/db/database_service.dart';
import 'package:example/provider/details_provider.dart';
import 'package:example/provider/download_provider.dart';
import 'package:example/provider/network/network_info.dart';
import 'package:example/provider/onboarding_notifier.dart';
import 'package:example/routes/router.dart';
import 'package:example/screens/home/core/application/search_notifier.dart';
import 'package:example/screens/home/core/insfrastructure/niveau_repository.dart';
import 'package:example/screens/pagination/paginate.dart';
import 'package:example/screens/ressources/core/application/activities_notifier.dart';
import 'package:example/screens/ressources/core/application/bank_notifier.dart';
import 'package:example/screens/ressources/core/application/class_activities_notifier.dart';
import 'package:example/screens/ressources/core/application/classe_notifier.dart';
import 'package:example/screens/ressources/core/application/fiche_notifier.dart';
import 'package:example/screens/ressources/core/application/history_notifier.dart';
import 'package:example/screens/home/core/application/niveau_notifier.dart';
import 'package:example/screens/ressources/core/application/online_notifier.dart';
import 'package:example/screens/ressources/core/application/ressource_notifier.dart';
import 'package:example/screens/ressources/core/domaine/ressources_item_page.dart';
import 'package:example/screens/ressources/core/insfrastructure/activities_repository.dart';
import 'package:example/screens/ressources/core/insfrastructure/ressource_repository.dart';
import 'package:example/widgets/helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/provider/network/injection_container.dart' as di;


final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return di.sl<NetworkInfo>();
});

final isConnectedProvider = FutureProvider<bool>((ref) async {
  final networkInfo = ref.read(networkInfoProvider);
  return await networkInfo.isConnected();
});

final appRouterProvider = Provider((ref) {
  return AppRouter(ref);
});

final detailProvider =
    ChangeNotifierProvider<DetailsProvider>((ref) => DetailsProvider());

final downloadProvider =
    ChangeNotifierProvider<DownloadProvider>((ref) => DownloadProvider());

final onBoardingProvider =
    StateNotifierProvider<OnboardingStateNotifier, OnboardingState>((ref) {
  return OnboardingStateNotifier(
      // ref.watch(onBoardingStorageProvider),
      );
});

final databaseProvider = FutureProvider<List<Ressources>>((ref) async {
  return await DatabaseService().getActivities();
});

final databasesProvider = FutureProvider<List<Ressources>>((ref) async {
  return await DatabaseService().getActivity();
});

final repositoryProviders =
    Provider.autoDispose.family((ref, String cancelToken) async {
  return RessourcesRepository(await ref.watch(databaseProvider.future));
});
final repositoryProvider = Provider((ref) async {
  return RessourcesRepository(await ref.watch(databaseProvider.future));
});

final niveauRepositoryProvider = Provider((ref) async {
  final bd = await ref.watch(databaseProvider.future);
  final typeId = convertLevel(ref.watch(downloadProvider).niveauStat);
  final List<Ressources> user = bd
      .where((activity) => activity.niveau!.any((type) => type == typeId))
      .toList();
  return NiveauRepository(user);
});

final allActivityNotifierProvider =
    StateNotifierProvider<SearchNotifier, FichesState>(
  (ref) {
    return SearchNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final activitiesRepositoryProvider = Provider((ref) async {
  return ActivitiesRepository(await ref.watch(databasesProvider.future));
});

final activitiesNotifierProvider =
    StateNotifierProvider<ClasseActivitiesNotifier, ClasseActivitiesState>(
  (ref) {
    return ClasseActivitiesNotifier(
      ref.watch(activitiesRepositoryProvider),
    );
  },
);

final ressourcesNotifierProvider =
    StateNotifierProvider<RessourceNotifier, RessourceState>(
  (ref) {
    return RessourceNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final activityNotifierProvider =
    StateNotifierProvider<ActivitiesNotifier, FichesState>(
  (ref) {
    return ActivitiesNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final niveauNotifierProvider =
    StateNotifierProvider<NiveauNotifier, FichesState>(
  (ref) {
    return NiveauNotifier(
      ref.watch(niveauRepositoryProvider),
    );
  },
);

final onLineNotifierProvider =
    StateNotifierProvider<OnlineNotifier, OnlineState>(
  (ref) {
    return OnlineNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final bankNotifierProvider = StateNotifierProvider<BankNotifier, BankState>(
  (ref) {
    return BankNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final classeNotifierProvider =
    StateNotifierProvider<ClasseNotifier, ClasseState>(
  (ref) {
    return ClasseNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final fichesNotifierProvider =
    StateNotifierProvider<FichesNotifier, FichesState>(
  (ref) {
    return FichesNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) {
    return HistoryNotifier(
      ref.watch(repositoryProvider),
    );
  },
);

// Provider pour filtrer les activités en fonction du type
final filteredActivityProvider =
    FutureProvider.family<List<Ressources>, String>((ref, typeId) async {
  final activities = await ref.watch(databaseProvider.future);
  return activities
      .where((activity) => activity.type!.any((type) => type.id == typeId))
      .toList();
});

final currentPageProvider = StateProvider<int>((ref) => 1);
final dataPageProvider = StateProvider<List<Ressources>?>((ref) => null);

final totalDataCountProvider = StateProvider<int>((ref) => 100);
final pageLimitProvider = StateProvider<int>((ref) => 10);
final pageLimitOptionsProvider =
    StateProvider<List<int>>((ref) => [10, 15, 25, 50]);

final zoomLimitOptionsProvider =
    StateProvider<List<int>>((ref) => [75, 100, 125]);

final paginateProvider =
    FutureProvider.family<RessourceItemPaged, List<Ressources>?>(
        (ref, liste) async {
  int page = ref.watch(currentPageProvider);
  int perPage = ref.watch(pageLimitProvider);
  int offset = (page - 1) * perPage;
  final int totalSize = (liste!.length / perPage).ceil();
  final data = liste
      .sublist(offset, min(offset + perPage, liste.length))
      .map((e) => e)
      .toList();
  ref.read(dataPageProvider.notifier).state = data;
  return RessourceItemPaged(
      page: page,
      data: data,
      hasNext: page < totalSize,
      hasPrev: page > 1,
      perPage: perPage,
      dataCount: liste.length,
      totalPages: totalSize);
});
