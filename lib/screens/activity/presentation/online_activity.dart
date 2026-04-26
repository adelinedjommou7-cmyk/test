import 'dart:io';
import 'dart:math';
import 'package:example/helpers/responsive_helper.dart';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/home.dart';
import 'package:example/screens/main_home.dart';
import 'package:example/screens/ressources/core/domaine/ressources_item_page.dart';
import 'package:example/screens/ressources/presentation/web.dart';
import 'package:example/screens/widget/custom_pagination.dart';
import 'package:example/screens/widget/custom_pagination_option.dart';
import 'package:example/widgets/custom_gridview.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class OnlineActivityPage extends ConsumerStatefulWidget {
  const OnlineActivityPage(
      {super.key,
      this.title = 'Activités en ligne',
      this.typeId = '5',
      this.data,
      required this.pageController});
  final List<Ressources>? data;
  final String typeId;
  final String title;
  final PageController pageController;
  @override
  _OnlineActivityPageState createState() => _OnlineActivityPageState();
}

class _OnlineActivityPageState extends ConsumerState<OnlineActivityPage>
    with TickerProviderStateMixin {
  String filterText = '';

  List<Ressources> displayElements = [];
  List<Ressources> display = [];

  final TextEditingController _searchController = TextEditingController();
  late List<Ressources> _filteredActivities;

  late final MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _filterActivities();
      displayElements = widget.data!;
    });
    _searchController.addListener(_filterActivities);
    print(localhostServer.documentRoot);
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
    _searchController.dispose();
    super.dispose();
  }

  static const pageSize = 20;
  ScrollController? controller;
  void _filterActivities() {
    final activities = ref.read(filteredActivityProvider(widget.typeId));
    activities.when(
      data: (data) {
        displayElements = data.where((activity) {
          final searchLower = _searchController.text.toLowerCase();
          final data = activity.title!.toLowerCase().contains(searchLower);
          return data;
        }).toList();
        setState(() {
          getPaginateData(displayElements);
        });
        if (mounted) setState(() {});
        _filteredActivities = displayElements;
      },
      error: (error, stack) => _filteredActivities = [],
      loading: () => _filteredActivities = [],
    );
  }

  void groupPerLetter(List<Ressources> elements) {
    setState(() {
      displayElements = elements;
      display.addAll(elements);
    });
  }

  RessourceItemPaged getPaginateData(List<Ressources> elements,
      {int page = 1}) {
    int perPage = ref.watch(pageLimitProvider);
    int offset = (page - 1) * perPage;
    final int totalSize = (elements.length / perPage).ceil();

    final data = elements
        .sublist(offset, min(offset + perPage, elements.length))
        .map((e) => e)
        .toList();

    print(' page: $page, indexInPage: ${data.length}');

    return RessourceItemPaged(
        page: page,
        data: data,
        hasNext: page < totalSize,
        hasPrev: page > 1,
        perPage: data.length,
        dataCount: elements.length,
        totalPages: totalSize);
  }

  _onPageLimitChanged(int? limit, List<Ressources>? data) async {
    setState(() {
      ref.read(currentPageProvider.notifier).state = 1;
      ref.read(pageLimitProvider.notifier).state = limit!;
      ref.read(dataPageProvider.notifier).state =
          getPaginateData(data!, page: 1).data;
    });

    // await _getSampleData();
  }

  _onChangePage(int page, List<Ressources> data) async {
    setState(() {
      ref.read(currentPageProvider.notifier).state = page;
      ref.read(dataPageProvider.notifier).state =
          getPaginateData(data, page: page).data;
    });
    // await _getSampleData();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final state = ref.read(onLineNotifierProvider.notifier).state;

    return ScaffoldPage(
        header: PageHeader(
          title: Text(widget.title),
          commandBar: SizedBox(
            width: 240.0,
            child: Tooltip(
              message: 'Recherche par title, categorie, niveau...',
              child: TextBox(
                // controller: _searchController,
                suffix: const Icon(FluentIcons.search),
                placeholder: 'Rechercher une activité',
                onChanged: (value) => setState(() {
                  ref.read(onLineNotifierProvider.notifier).searchRessource(
                      typeId: widget.typeId, searchItem: value);
                }),
              ),
            ),
          ),
        ),
        bottomBar: SizedBox(
          width: double.infinity,
          child: state.map(
            initial: (value) {
              return Container();
            },
            loadInProgress: (value) {
              return const InfoBar(
                title: Text('Conseil:'),
                content: Text(
                  'Vous pouvez cliquer sur n\'importe quelle item pour consulter ces details !',
                ),
              );
            },
            loadSuccess: (value) {
              final data = value.result;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomPaginationOptions(
                    limitPerPage: ref.watch(pageLimitProvider),
                    backgroundColor: Colors.grey,
                    // textStyle: _textStyle,
                    pageLimitOptions: ref.watch(pageLimitOptionsProvider),
                    onPageLimitChanged: (p) {
                      _onPageLimitChanged(p, data);
                    },
                    text: 'éléments par page',
                  ),
                  CustomPagination(
                    currentPage: ref.watch(currentPageProvider),
                    limitPerPage: ref.watch(pageLimitProvider),
                    totalDataCount: data!.isNotEmpty
                        ? data.length
                        : ref.watch(totalDataCountProvider),
                    onPreviousPage: (p) {
                      _onChangePage(p, data);
                    },
                    onBackToFirstPage: (p) {
                      _onChangePage(p, data);
                    },
                    onNextPage: (p) {
                      _onChangePage(p, data);
                    },
                    onGoToLastPage: (p) {
                      _onChangePage(p, data);
                    },
                    previousPageIcon: m.Icons.keyboard_arrow_left,
                    backToFirstPageIcon: m.Icons.first_page,
                    nextPageIcon: m.Icons.keyboard_arrow_right,
                    goToLastPageIcon: m.Icons.last_page,
                  ),
                ],
              );
            },
            loadFailure: (value) {
              return Container();
            },
          ),
        ),
        content: state.map(
          initial: (value) {
            return Center(child: m.CircularProgressIndicator());
          },
          loadInProgress: (value) {
            final data = value.result;
            return customItem(data);
          },
          loadSuccess: (value) {
            final data = value.result;
            return customItem(data);
          },
          loadFailure: (value) {
            return Center(child: m.CircularProgressIndicator());
          },
        )
        // Column(
        //   children: [
        //     Expanded(
        //         child: ),
        //   ],
        // ),
        );
  }

  _onPageChanged(int page) {
    getPaginateData(widget.data!, page: page);
  }

  static String snakeCasetoSentenceCase(String original) {
    return '${original[0].toUpperCase()}${original.substring(1)}'
        .replaceAll(RegExp(r'(_|-)+'), ' ');
  }

  int _getOptimalCrossAxisCount(
      BuildContext context, ResponsiveHelper _respHelper) {
    return _respHelper.isDesktop
        ? 4
        : _respHelper.isTablet()
            ? 3
            : 2;
  }

  Widget customItem(List<Ressources>? data) {
    return data!.isEmpty
        ? Center(
            child: Lottie.asset(
              "assets/json/placeholder.json",
              // controller: _controller,
              height: MediaQuery.of(context).size.height * 0.4,
              animate: true,
              onLoaded: (composition) {
                // _controller!
                //   ..duration = composition.duration
                //   ..forward().whenComplete(() async {
                //   });
              },
            ),
          )
        : CustomGridview(
            itemCount: data.isNotEmpty
                ? (ref.watch(dataPageProvider) != null)
                    ? ref.watch(dataPageProvider)!.length
                    : getPaginateData(data).perPage
                : data.length,
            itemBuilder: (context, index) {
              final e = (ref.watch(dataPageProvider) != null)
                  ? ref.watch(dataPageProvider)!.elementAt(index)
                  : getPaginateData(data).data.elementAt(index);

              return CustomCardItem(
                data: e,
                width: 290,
              );
            },
          );
  }
}
