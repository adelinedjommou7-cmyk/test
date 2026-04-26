import 'package:example/keys/licence_manager.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/home_main.dart';
import 'package:example/screens/activity/presentation/main_activity.dart';
// import 'package:example/screens/ressources/presentation/bank_Activity.dart';
// import 'package:example/screens/ressources/presentation/classe_activity.dart';
// import 'package:example/screens/ressources/presentation/fiches_activity.dart';
// import 'package:example/screens/ressources/presentation/historique_activity.dart';
// import 'package:example/screens/ressources/presentation/jeux_activity.dart';
// import 'package:example/screens/ressources/presentation/online_activity.dart';
// import 'package:example/screens/ressources/presentation/ressources.dart';
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

import 'package:example/screens/home/presentation/ressources.dart';
import 'package:example/screens/settings.dart' deferred as settings;
import 'package:example/widgets/deferred_widget.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:example/widgets/router.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:window_manager/window_manager.dart';

import '../main.dart';
import '../theme.dart';

final localhostServer = InAppLocalhostServer(
    documentRoot: CashHelper.getData(key: 'html'), shared: true);

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool _initialUriIsHandled = false;
final indexPage = StateProvider<int>((ref) => 0);
final isCloneHome = StateProvider<bool>((ref) => false);
final isNotExpired = StateProvider<bool>((ref) => false);

class _MyHomePageState extends ConsumerState<MyHomePage> with WindowListener {
  LicenseManager licenseManager = LicenseManager();
  bool value = false;

  // int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  var cloneKey = '/';

  late final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const ValueKey('/'),
      icon: const Icon(FluentIcons.home),
      title: const Text('Accueil'),
      body: const SizedBox.shrink(),
      focusNode: focusNode1,
    ),
    PaneItemHeader(header: const Text('Categories')),
    PaneItem(
      key: const ValueKey('/category/activite_en_ligne'),
      icon: const Icon(FluentIcons.button_control),
      title: const Text('Activités en ligne'),
      body: const SizedBox.shrink(),
      focusNode: focusNode2,
    ),
    PaneItem(
      key: const ValueKey('/category/b_projet_stim'),
      icon: const Icon(FluentIcons.checkbox_composite),
      title: const Text('Banque de projets STIM'),
      body: const SizedBox.shrink(),
      focusNode: focusNode3,
    ),
    PaneItem(
      key: const ValueKey('/category/fiche_activite'),
      icon: const Icon(FluentIcons.toggle_left),
      title: const Text('Fiches d’activités'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey('/category/jeu_en_ligne'),
      icon: const Icon(FluentIcons.game),
      title: const Text('Jeux en ligne'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey('/category/historiq_perso'),
      icon: const Icon(FluentIcons.book_answers),
      title: const Text('Histoires personnalisées'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey('/category/material_class'),
      icon: const Icon(FluentIcons.class_notebook_logo_inverse),
      title: const Text('Matériel de classe'),
      body: const SizedBox.shrink(),
    ),
    // // TODO: Scrollbar, RatingBar
  ].map<NavigationPaneItem>((e) {
    PaneItem buildPaneItem(PaneItem item) {
      return PaneItem(
        key: item.key,
        icon: item.icon,
        title: item.title,
        body: item.body,
        onTap: () {
          cleanData();
          final path = (item.key as ValueKey).value;
          setState(() => ref
              .read(indexPage.notifier)
              .update((state) => state = convertRessourceIndex(index: path)));
          // ref.watch(ressourcesNotifierProvider.notifier).fetchRessource(
          //     typeId: convertRessourceIndex(index: path).toString());
          if (cloneKey != path) {
            context.go(path);
            setState(() {
              cloneKey = path;
            });
          } else {
            context.go(path);
            item.onTap?.call();
            print(path);
          }
        },
      );
    }

    if (e is PaneItemExpander) {
      return PaneItemExpander(
        key: e.key,
        icon: e.icon,
        title: e.title,
        body: e.body,
        items: e.items.map((item) {
          if (item is PaneItem) return buildPaneItem(item);
          return item;
        }).toList(),
      );
    }
    if (e is PaneItem) return buildPaneItem(e);
    return e;
  }).toList();
  late final List<NavigationPaneItem> footerItems = [
    // PaneItem(
    //   key: const ValueKey('/empty_registre'),
    //   icon: const Icon(
    //     FluentIcons.settings,
    //   ),
    //   title: const Text('Settings'),
    //   body: Lottie.asset(
    //     "assets/json/empty_registre.json",
    //     width: 200,
    //     height: 200,
    //     fit: BoxFit.fill,
    //     frameRate: FrameRate(10),
    //     animate: false,
    //   ),
    // ),
    PaneItemSeparator(),
    PaneItem(
      key: const ValueKey('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {
        cleanData();
        setState(() => ref.read(indexPage.notifier).update(
            (state) => state = convertRessourceIndex(index: '/settings')));
        if (cloneKey != '/settings') {
          context.go('/settings');
          setState(() {
            cloneKey = '/settings';
          });
        }
        // if (GoRouterState.of(context).uri.toString() != '/settings') {
        //   context.go('/settings');
        // }
      },
    ),
    // LinkPaneItemAction(
    //   icon: const Icon(FluentIcons.open_source),
    //   title: const Text('Source code'),
    //   link: 'https://github.com/bdlukaa/fluent_ui',
    //   body: const SizedBox.shrink(),
    // ),
  ];

  void cleanData() {
    setState(() {
      ref.read(isCloneHome.notifier).state = false;
      ref.read(currentPageProvider.notifier).state = 1;
      ref.read(dataPageProvider.notifier).state = null;
      ref.read(pageLimitProvider.notifier).state = 10;
    });
  }

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  @override
  void initState() {
    windowManager.addListener(this);
    if (!kIsWeb) {
      // starServer();
    }
    licenseManager.init();
    Future.microtask(() {
      ref.watch(havorisProvider).getRessourcesList();
      ref.read(niveauNotifierProvider.notifier).fetchRessource(
          niveau: convertLevel(ref.watch(downloadProvider).niveau!));
      ref.read(activityNotifierProvider.notifier).fetchRessource();
      ref.read(ressourcesNotifierProvider.notifier).fetchRessource();
      ref.read(fichesNotifierProvider.notifier).fetchRessource();
      ref.read(historyNotifierProvider.notifier).fetchRessource();
      ref.read(onLineNotifierProvider.notifier).fetchRessource();
      ref.read(bankNotifierProvider.notifier).fetchRessource();
      ref.read(classeNotifierProvider.notifier).fetchRessource();
      ref.read(activitiesNotifierProvider.notifier).fetchRessource();
      ref.read(allActivityNotifierProvider.notifier).fetchRessource();
      final isThemeSet = CashHelper.getData(key: 'theme') ?? 1;
      final appTheme = ref.watch(themeProvider);
      final mode = ThemeMode.values[isThemeSet];
      appTheme.mode = mode;
      appTheme.setEffect(appTheme.windowEffect, context);
    });
    super.initState();
  }

  Future<void> starServer() async {
    await localhostServer.start();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();

    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    // final location = GoRouterState.of(context).uri.toString();

    int indexOriginal = originalItems
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(cloneKey));

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == Key(cloneKey));
      if (indexFooter == -1) {
        return 0;
      }

      return originalItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final localizations = FluentLocalizations.of(context);
    // final appTheme = context.watch<AppTheme>();
    final appTheme = ref.watch(themeProvider);
    // final index = ref.watch(indexPage);
    Future.wait([
      DeferredWidget.preload(bank.loadLibrary),
      DeferredWidget.preload(classe.loadLibrary),
      DeferredWidget.preload(fiches.loadLibrary),
      DeferredWidget.preload(history.loadLibrary),
      DeferredWidget.preload(jeux.loadLibrary),
      DeferredWidget.preload(online.loadLibrary),
      DeferredWidget.preload(settings.loadLibrary),
    ]);

    // final theme = FluentTheme.of(context);
    // if (widget.shellContext != null) {
    //   if (router.canPop() == false) {
    //     setState(() {});
    //   }
    // }

    var viewPage = [
      // ref.watch(isCloneHome)
      //     ? RessourcesPage(
      //         data: ref.watch(niveauNotifierProvider).result,
      //       )
      //     :
      const HomeMainPage(),
      const MainActivityPage(),
      // DeferredWidget(
      //   online.loadLibrary,
      //   () => online.OnlineActivityPage(
      //     data: activiteLigneList,
      //     typeId: '5',
      //     title: convertRessourceTitle(index: 5),
      //   ),
      // ),
      DeferredWidget(
        bank.loadLibrary,
        () => bank.BankActivityPage(
          data: banqueProjetList,
          typeId: '2',
          title: convertRessourceTitle(index: 2),
        ),
      ),
      DeferredWidget(
        fiches.loadLibrary,
        () => fiches.FichesActivityPage(
          data: ficheActiviteList,
          typeId: '1',
          title: convertRessourceTitle(index: 1),
        ),
      ),
      DeferredWidget(
        jeux.loadLibrary,
        () => jeux.JeuxActivityPage(
          data: ref.read(filteredActivityProvider('6')).value,
          typeId: '6',
          title: convertRessourceTitle(index: 6),
        ),
      ),
      DeferredWidget(
        history.loadLibrary,
        () => history.HistoriqueActivityPage(
          data: histoiresPersonnaList,
          typeId: '3',
          title: convertRessourceTitle(index: 3),
        ),
      ),
      DeferredWidget(
        classe.loadLibrary,
        () => classe.ClasseActivityPage(
          data: materielClassList,
          typeId: '4',
          title: convertRessourceTitle(index: 4),
        ),
      ),
      DeferredWidget(
        settings.loadLibrary,
        () => settings.Settings(),
      ),
    ];

    // return FutureBuilder<bool>(
    //   future: licenseManager.validateLicense(ref),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: const m.CircularProgressIndicator());
    //     } else if (snapshot.hasData && snapshot.data == true) {
    return NavigationView(
      key: viewKey,
      titleBar: TitleBar(
        title: () {
          if (kIsWeb) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                appTitle,
                style: TextStyle(fontSize: 14),
              ),
            );
          }
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                appTitle,
                style: TextStyle(fontSize: 15),
              ),
            ),
          );
        }(),
        endHeader: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (!kIsWeb) WindowButtons(),
        ]),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: viewPage[ref.watch(indexPage)],
          // child: Container(
          //   color: Colors.red,
          // ),
        );
      },
      pane: NavigationPane(
        selected: ref.watch(indexPage), //  _calculateSelectedIndex(context),
        header: SizedBox(
          height: 200,
          child: Image.asset(
            'assets/icons/icon.png',
            width: 200,
            height: 200,
          ),
        ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
        autoSuggestBox: Builder(builder: (context) {
          return AutoSuggestBox(
            key: searchKey,
            focusNode: searchFocusNode,
            controller: searchController,
            unfocusedColor: Colors.transparent,
            // also need to include sub items from [PaneItemExpander] items
            items: <PaneItem>[
              ...originalItems
                  .whereType<PaneItemExpander>()
                  .expand<PaneItem>((item) {
                return [
                  item,
                  ...item.items.whereType<PaneItem>(),
                ];
              }),
              ...originalItems
                  .where(
                    (item) => item is PaneItem && item is! PaneItemExpander,
                  )
                  .cast<PaneItem>(),
            ].map((item) {
              assert(item.title is Text);
              final text = (item.title as Text).data!;
              return AutoSuggestBoxItem(
                label: text,
                value: text,
                onSelected: () {
                  item.onTap?.call();
                  searchController.clear();
                  searchFocusNode.unfocus();
                  final view = NavigationView.of(context);
                  if (view.compactOverlayOpen) {
                    view.compactOverlayOpen = false;
                  } else if (view.isMinimalPaneOpen) {
                    view.isMinimalPaneOpen = false;
                  }
                },
              );
            }).toList(),
            trailingIcon: IgnorePointer(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(FluentIcons.search),
              ),
            ),
            placeholder: 'Rechercher un menu',
          );
        }),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: searchFocusNode.requestFocus,
    );
    //     } else {
    //       return const LicenseErrorScreen();
    //     }
    //   },
    // );
  }

  /// Alert dialog for save and export
  void _showDialog(String text, String outputFile) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return ContentDialog(
            title: const Text('Document enregistré'),
            content: SizedBox(
              width: 328.0,
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Text(text),
                ),
              ),
            ),
            actions: <Widget>[
              FilledButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text('D\'accord'),
              )
            ],
          );
        });
  }

  @override
  void onWindowClose() async {
    bool isPreventCloses = false;
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {
      showDialog(
        context: context,
        builder: (_) {
          return isPreventCloses
              ? const ContentDialog(
                  title: Text('Confirmer la fermeture'),
                  content: m.CircularProgressIndicator.adaptive(),
                )
              : ContentDialog(
                  title: const Text('Confirmer la fermeture'),
                  content: const Text(
                      'Êtes-vous sûr de vouloir fermer l\'application Seeva maintenant?'),
                  actions: [
                    FilledButton(
                      child: const Text('Oui'),
                      onPressed: () async {
                        setState(() {
                          isPreventCloses = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        windowManager.destroy();
                      },
                    ),
                    Button(
                      child: const Text('Non par maintenant'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
        },
      );
    }
  }
}

// OnlineActivityPage(
//   data: activiteLigneList,
//   typeId: '5',
//   title: convertRessourceTitle(index: 5),
// ),
// BankActivityPage(
//   data: banqueProjetList,
//   typeId: '2',
//   title: convertRessourceTitle(index: 2),
// ),
// FichesActivityPage(
//   data: ficheActiviteList,
//   typeId: '1',
//   title: convertRessourceTitle(index: 1),
// ),
// JeuxActivityPage(
//   data: ref.read(filteredActivityProvider('6')).value,
//   typeId: '6',
//   title: convertRessourceTitle(index: 6),
// ),
// HistoriqueActivityPage(
//   data: histoiresPersonnaList,
//   typeId: '3',
//   title: convertRessourceTitle(index: 3),
// ),
// ClasseActivityPage(
//   data: materielClassList,
//   typeId: '4',
//   title: convertRessourceTitle(index: 4),
// ),
// Settings(),
