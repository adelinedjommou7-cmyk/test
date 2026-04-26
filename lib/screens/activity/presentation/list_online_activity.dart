import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/ressources.dart';
import 'package:example/screens/main_home.dart';
import 'package:example/screens/ressources/presentation/web.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListOnlineActivityPage extends ConsumerStatefulWidget {
  const ListOnlineActivityPage(
      {super.key, this.data, required this.pageController});
  final List<Ressources>? data;
  final PageController pageController;
  @override
  _ListOnlineActivityPageState createState() => _ListOnlineActivityPageState();
}

class _ListOnlineActivityPageState extends ConsumerState<ListOnlineActivityPage>
    with TickerProviderStateMixin {
  String filterText = '';

  List<Ressources> displayElements = [];
  List<Ressources> display = [];

  final TextEditingController _searchController = TextEditingController();
  late List<Ressources> _filteredActivities;

  @override
  void initState() {
    super.initState();
    print(localhostServer.documentRoot);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ScrollController? controller;
  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final state = ref.read(activitiesNotifierProvider.notifier).state;

    Map<String, List<Ressources>> groupPerMethod(List<Ressources> elements) {
      final Map<String, List<Ressources>> transactionMethodsMap = {};
      //  elements.sort((a, b) => a.categorie!.compareTo(b.categorie!));
      final list = elements;
      for (final Ressources e in list) {
        final key = e.categorie;
        if (transactionMethodsMap[key] == null) {
          transactionMethodsMap[key!] = [e];
        } else {
          transactionMethodsMap[key]!.add(e);
        }
      }
      return transactionMethodsMap;
    }

    int itemCountValue(List<Ressources> transactionData) {
      final itemCount = groupPerMethod(transactionData).length;
      return itemCount;
    }

    return ScaffoldPage(
      // header: PageHeader(
      //   title: Text(widget.title),
      //   commandBar: SizedBox(
      //     width: 240.0,
      //     child: Tooltip(
      //       message: 'Recherche par title, categorie, niveau...',
      //       child: TextBox(
      //         // controller: _searchController,
      //         suffix: const Icon(FluentIcons.search),
      //         placeholder: 'Rechercher une activité',
      //         onChanged: (value) => setState(() {
      //           ref.read(onLineNotifierProvider.notifier).searchRessource(
      //               typeId: widget.typeId, searchItem: value);
      //         }),
      //       ),
      //     ),
      //   ),
      // ),
      content: MasonryGridView.builder(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return IntrinsicHeight(
              child: state.map(
            initial: (value) {
              return const Center(child: m.CircularProgressIndicator());
            },
            loadInProgress: (value) {
              final transactionMethodsMap = groupPerMethod(value.result!);
              final String key =
                  transactionMethodsMap.keys.toList().elementAt(index);
              final List<Ressources> elements = transactionMethodsMap[key]!;
              return TransactionSuperTile(
                elements: elements,
                dateHeader: key,
                heroTag: index,
              );
            },
            loadSuccess: (value) {
              final transactionMethodsMap = groupPerMethod(value.result!);
              final String key =
                  transactionMethodsMap.keys.toList().reversed.elementAt(index);
              final List<Ressources> elements = transactionMethodsMap[key]!;
              return TransactionSuperTile(
                elements: elements,
                dateHeader: key,
                heroTag: index,
              );
            },
            loadFailure: (value) {
              return const Center(child: m.CircularProgressIndicator());
            },
          ));
        },
        itemCount: state.map(
          initial: (_) => 6,
          loadInProgress: (data) => itemCountValue(data.result!),
          loadSuccess: (data) => itemCountValue(data.result!),
          loadFailure: (data) => itemCountValue(data.result!),
        ),
      ),
    );
  }
}

class TransactionSuperTile extends ConsumerStatefulWidget {
  const TransactionSuperTile(
      {super.key,
      required this.elements,
      required this.dateHeader,
      required this.heroTag});
  final List<Ressources> elements;
  final String dateHeader;
  final int heroTag;
  @override
  ConsumerState<TransactionSuperTile> createState() =>
      _TransactionSuperTileState();
}

class _TransactionSuperTileState extends ConsumerState<TransactionSuperTile> {
  int countSim = 0;
  late final MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    PullToRefreshController? pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.black,
            ),
            onRefresh: () async {
              if (Platform.isAndroid) {
                browser.webViewController?.reload();
              } else if (Platform.isIOS) {
                browser.webViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await browser.webViewController?.getUrl()));
              }
            },
          );

    browser = MyInAppBrowser(pullToRefreshController: pullToRefreshController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _hovered = false;

  List colors = [
    Colors.red.withOpacity(0.01),
    Colors.green.withOpacity(0.01),
    Colors.yellow.withOpacity(0.01)
  ];
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    const animationCurve = Curves.easeInOut;
    final borderRadius = BorderRadius.circular(_hovered ? 8 : 0);

    // ignore: unused_local_variable
    // final simPos = ref.read(simCardProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: (4.0),
            bottom: (8),
            top: (8.0),
          ),
          child: Text(
            widget.dateHeader,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color: colors[widget.heroTag],
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.withOpacity(0.01)
                  : const Color(0xffF7F9FA),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  (8),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(widget.elements.length, (index) {
                  final element = widget.elements[index];

                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _hovered = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _hovered = false;
                      });
                    },
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onDoubleTap: () async {
                        final copyText = '${element.title}';
                        await FlutterClipboard.copy(copyText);
                        if (context.mounted) {
                          showCopiedSnackbar(context, copyText);
                        }
                      },
                      onTap: () {},
                      child: AnimatedContainer(
                        duration: kThemeAnimationDuration,
                        curve: animationCurve,
                        foregroundDecoration: BoxDecoration(
                          color: m.Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(
                                _hovered ? 0.12 : 0,
                              ),
                          borderRadius: borderRadius,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () async {
                            SystemSound.play(Platform.isMacOS
                                ? SystemSoundType.alert
                                : SystemSoundType.click);
                            await browser.openUrlRequest(
                              urlRequest: URLRequest(
                                  url: WebUri(
                                      'http://127.0.0.1:8080/${element.localLink}')), //webWhatsappUrl
                              settings: InAppBrowserClassSettings(
                                browserSettings: InAppBrowserSettings(
                                    toolbarTopBackgroundColor: Colors.blue,
                                    presentationStyle:
                                        ModalPresentationStyle.POPOVER),
                                webViewSettings: InAppWebViewSettings(
                                  isInspectable: kDebugMode,
                                  useShouldOverrideUrlLoading: true,
                                  useOnLoadResource: true,
                                ),
                              ),
                            );
                          },
                          child: TweenAnimationBuilder<BorderRadius>(
                            duration: kThemeAnimationDuration,
                            curve: animationCurve,
                            tween: Tween(
                                begin: BorderRadius.zero, end: borderRadius),
                            builder: (context, borderRadius, child) => Text(
                              element.title!,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                // ...widget.elements
                //     .map(
                //       (Ressources element) => ,
                //     )
                //     .toList(),
                const SizedBox(
                  height: 10,
                ),
                // .reversed
              ],
            )),
      ],
    );
  }
}
