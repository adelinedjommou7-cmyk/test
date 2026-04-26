// ignore_for_file: unused_import
import 'package:example/app_lifecycle/app_lifecycle.dart';
import 'package:example/audio/audio_controller.dart';
import 'package:example/audio/audio_setting.dart';
import 'package:example/files/folders.dart';
import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:process_run/process_run.dart' as process_run;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:example/screens/ressources/core/domaine/save_ressource_list.dart';
import 'package:example/widgets/hot_keys.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:example/models/ressources.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:convert';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:example/screens/ressources/presentation/bank_Activity.dart'
    deferred as bank;
import 'package:example/screens/ressources/presentation/classe_activity.dart'
    deferred as classe;
import 'package:example/screens/ressources/presentation/fiches_activity.dart'
    deferred as fiches;
import 'package:example/screens/ressources/presentation/historique_activity.dart'
    deferred as history;
import 'package:example/screens/ressources/presentation/jeux_activity.dart'
    deferred as jeux;
import 'package:example/screens/activity/presentation/online_activity.dart'
    deferred as online;
import 'package:example/screens/home/presentation/ressources.dart'
    deferred as ressources;
import 'package:example/screens/settings.dart' deferred as settings;
import 'package:example/provider/network/injection_container.dart' as di;
import 'theme.dart';
import 'widgets/deferred_widget.dart';
import 'widgets/router.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hotkey_manager/hotkey_manager.dart';

const String appTitle = 'Seeva Education';
const String imgPlaceHolder = 'assets/images/placeholder.png';
bool? seenOnboard;
// final localhostServer = InAppLocalhostServer(
//   documentRoot:
//       'assets/jeux/Argent Argent-Jeu de mémoire -  Monnaie canadienne/',
// );
// late Localstore db;

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

const JsonDecoder decoder = JsonDecoder();
List<Ressources> result = [];
List<Ressources> jeuResult = [];
List<Ressources> ficheActiviteList = [];
List<Ressources> banqueProjetList = [];
List<Ressources> histoiresPersonnaList = [];
List<Ressources> materielClassList = [];
List<Ressources> jeuEnLigneList = [];
List<Ressources> activiteLigneList = [];

// final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
final FileManagerController controller = FileManagerController();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initHive();
  // if (!kIsWeb) {
  //   await localhostServer.start();
  // }
  await di.init();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {}
  // if it's not on the web, windows or android, load the accent color
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }
  await CashHelper.init();
  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await flutter_acrylic.Window.hideWindowControls();
    }
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.center(animate: true);
      // await windowManager.setMinimizable(const Size(755, 600)); //,800, 650
      await windowManager.setMinimumSize(const Size(940, 600)); //, 545,5001280,
      await windowManager.setSize(const Size(900, 650));
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
      await windowManager.setAsFrameless();
    });
  }

  //synchronously read file contents
  final data = loadJsonData();
  final jeuData = loadsJsonData('activity');
  // final data = Ressources.fromJson(loadJsonData() as Map<String, dynamic>);
  //pass the read string to JsonDecoder class to convert into corresponding Objects
  final list = await data;
  final jeulist = await jeuData;

  result = list.map((item) {
    return Ressources.fromJson(item);
  }).toList();

  jeuResult = jeulist.map((item) {
    return Ressources.fromJson(item);
  }).toList();
  // print(result.length);
  // print(jeuResult.length);

  // Filtrer la liste pour obtenir les éléments qui répondent aux critères spécifiés
  loadList(result);
  // Lire les fichiers de jeu au lancement de l'application
  await readGameFiles();
  runApp(const ProviderScope(child: MyApp()));
  // runApp(const AppLifecycleObserver(child: ProviderScope(child: MyApp())));
  Future.wait([
    DeferredWidget.preload(bank.loadLibrary),
    DeferredWidget.preload(classe.loadLibrary),
    DeferredWidget.preload(fiches.loadLibrary),
    DeferredWidget.preload(history.loadLibrary),
    DeferredWidget.preload(jeux.loadLibrary),
    DeferredWidget.preload(online.loadLibrary),
    DeferredWidget.preload(ressources.loadLibrary),
    DeferredWidget.preload(settings.loadLibrary),
  ]);
}

void loadList(List<Ressources> result) {
  ficheActiviteList = result.where((item) {
    return item.type != null &&
        item.type!.any((typeItem) => typeItem.id == "1");
  }).toList();
  // print("ficheActiviteList : ${ficheActiviteList.length}");

  banqueProjetList = result.where((item) {
    return item.type != null &&
        item.type!.any((typeItem) => typeItem.id == "2");
  }).toList();
  // print("banqueProjetList : ${banqueProjetList.length}");

  histoiresPersonnaList = result.where((item) {
    return item.type != null &&
        item.type!.any((typeItem) => typeItem.id == "3");
  }).toList();
  // print("histoiresPersonnaList : ${histoiresPersonnaList.length}");

  materielClassList = result.where((item) {
    return item.type != null &&
        item.type!.any((typeItem) => typeItem.id == "4");
  }).toList();
  // print("materielClassList : ${materielClassList.length}");

  activiteLigneList = result.where((item) {
    return item.type != null &&
        item.type!.any((typeItem) => typeItem.id == "5");
  }).toList();
  // print("activiteLigneList : ${activiteLigneList.length}");

  jeuEnLigneList = jeuResult.where((item) {
    return item.type!.any((typeItem) => typeItem.id == "6");
  }).toList();
  // print("jeuEnLigneList : ${jeuEnLigneList.length}");
}

Future<List> loadJsonData() async {
  final jsonString = await rootBundle.loadString('assets/json/ressources.json');
  return json.decode(jsonString);
}

Future<List> loadsJsonData(String item) async {
  final jsonString = await rootBundle.loadString('assets/json/$item.json');
  return json.decode(jsonString);
}

dynamic myEncode(dynamic item) {
  // Cette fonction assure que tout objet non encodable nativement soit converti en string
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item;
}

final _appTheme = AppTheme();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final appTheme = context.watch<AppTheme>();
    final appTheme = ref.watch(themeProvider);

    return FluentApp.router(
      title: appTitle,
      themeMode: appTheme.mode,
      debugShowCheckedModeBanner: false,
      color: appTheme.color,
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      theme: FluentThemeData(
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      locale: appTheme.locale,
      // home: const SplashPage(),
      // routerConfig: appRouter.config(
      //   navigatorObservers: () => [
      //     AutoRouteObserver(),
      //   ],
      // ),
      // builder: (context, child) {
      //   return Directionality(
      //     textDirection: appTheme.textDirection,
      //     child: NavigationPaneTheme(
      //       data: NavigationPaneThemeData(
      //         backgroundColor: appTheme.windowEffect !=
      //                 flutter_acrylic.WindowEffect.disabled
      //             ? Colors.transparent
      //             : null,
      //       ),
      //       child: child!,
      //     ),
      //   );
      // },
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );

    // ChangeNotifierProvider.value(
    //   value: _appTheme,
    //   builder: (context, child) {
    //     final appTheme = context.watch<AppTheme>();
    //     return
    //   },
    // );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

Future<void> initHive() async {
  // final appDocumentDirectory = await getApplicationDocumentsDirectory();
  // Hive
  //   ..initFlutter()
  //   ..init(appDocumentDirectory.path)
  //   ..registerAdapter(RessourcesAdapter());
  // await Hive.openBox<Ressources>('todos');
  //  await Hive.initFlutter('Seeva');
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/seeva/$boxName.hive');
      lockFile = File('$dirPath/seeva/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });

  if (limit && box.length > 500) {
    box.clear();
  }
}
