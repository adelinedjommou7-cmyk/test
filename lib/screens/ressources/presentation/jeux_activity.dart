import 'dart:math';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/home.dart';
import 'package:example/screens/ressources/core/domaine/ressources_item_page.dart';
import 'package:example/screens/widget/custom_pagination.dart';
import 'package:example/screens/widget/custom_pagination_option.dart';
import 'package:example/widgets/custom_gridview.dart';
import 'package:example/widgets/empty_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

Future<void> showCopiedSnackbar(BuildContext context, String copiedText) {
  return displayInfoBar(
    context,
    builder: (context, close) => InfoBar(
      title: RichText(
        text: TextSpan(
          text: 'Copied ',
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: copiedText,
              style: TextStyle(
                color: Colors.blue.defaultBrushFor(
                  FluentTheme.of(context).brightness,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class JeuxActivityPage extends ConsumerStatefulWidget {
  const JeuxActivityPage(
      {super.key,
      this.title = 'Activités en ligne',
      this.typeId = '6',
      this.data});
  final List<Ressources>? data;
  final String typeId;
  final String title;
  @override
  _JeuxActivityPageState createState() => _JeuxActivityPageState();
}

class _JeuxActivityPageState extends ConsumerState<JeuxActivityPage>
    with TickerProviderStateMixin {
  String filterText = '';

  List<Ressources> displayElements = [];
  List<Ressources> display = [];

  final TextEditingController _searchController = TextEditingController();
  // late List<Ressources> _filteredActivities;

  int currentPage = 1;
  int pageLimit = 10;
  List<int> pageLimitOptions = [10, 25, 50];
  int totalDataCount = 100;
  dynamic sampleData = [];

  // Liste de FocusNode pour chaque élément de la liste
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .watch(ressourcesNotifierProvider.notifier)
        .fetchRessource(typeId: widget.typeId));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _filterActivities();
      // displayElements = widget.data!;
    });
    // _searchController.addListener(_filterActivities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // static const pageSize = 20;
  ScrollController? controller;
  // void _filterActivities() {
  //   final activities = ref.read(filteredActivityProvider(widget.typeId));
  //   activities.when(
  //     data: (data) {
  //       displayElements = data.where((activity) {
  //         final searchLower = _searchController.text.toLowerCase();
  //         final data = activity.title!.toLowerCase().contains(searchLower);
  //         return data;
  //       }).toList();
  //       setState(() {
  //         getPaginateData(displayElements);
  //       });
  //       if (mounted) setState(() {});
  //       _filteredActivities = displayElements;
  //     },
  //     error: (error, stack) => _filteredActivities = [],
  //     loading: () => _filteredActivities = [],
  //   );
  // }

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

    for (int i = 0; i < data.length; i++) {
      focusNodes.add(FocusNode());
    }

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
      currentPage = 1;
      pageLimit = limit ?? 15;
      ref.read(currentPageProvider.notifier).state = 1;
      ref.read(pageLimitProvider.notifier).state = limit!;
      ref.read(dataPageProvider.notifier).state =
          getPaginateData(data!, page: 1).data;
    });

    // await _getSampleData();
  }

  _onChangePage(int page, List<Ressources> data) async {
    setState(() {
      currentPage = page;
      ref.read(currentPageProvider.notifier).state = page;
      ref.read(dataPageProvider.notifier).state =
          getPaginateData(data, page: page).data;
    });
    // await _getSampleData();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    ref
        .watch(ressourcesNotifierProvider.notifier)
        .fetchRessource(typeId: widget.typeId);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    final state = ref.read(ressourcesNotifierProvider.notifier).state;
    // final ResponsiveHelper respHelper = ResponsiveHelper(context: context);

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            FocusScope.of(context).nextFocus();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            FocusScope.of(context).previousFocus();
          }
        }
      },
      child: ScaffoldPage(
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
                    ref
                        .read(ressourcesNotifierProvider.notifier)
                        .searchRessource(
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
                      currentPage: currentPage,
                      limitPerPage: ref.watch(pageLimitProvider),
                      totalDataCount:
                          data!.isNotEmpty ? data.length : totalDataCount,
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
              return const Center(child: m.CircularProgressIndicator());
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
              return const Center(child: m.CircularProgressIndicator());
            },
          )),
    );
  }

  Widget customItem(List<Ressources>? data) {
    return data!.isEmpty
        ? const CustomEmptyPage(
            url: "assets/gifs/GIF 7.gif",
          )
        : Column(
            children: [
              Expanded(
                  child: CustomGridview(
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
              )

                  // GridView.builder(
                  //   padding: EdgeInsetsDirectional.only(
                  //     start: PageHeader.horizontalPadding(context),
                  //     end: PageHeader.horizontalPadding(context),
                  //   ),
                  //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  //     maxCrossAxisExtent: 290,
                  //     crossAxisSpacing: 6,
                  //     mainAxisSpacing: 10,
                  //     mainAxisExtent: 270,
                  //   ),
                  //   itemCount: data.isNotEmpty
                  //       ? (ref.watch(dataPageProvider) != null)
                  //           ? ref.watch(dataPageProvider)!.length
                  //           : getPaginateData(data).perPage
                  //       : data.length,
                  //   itemBuilder: (context, index) {
                  //     final e = (ref.watch(dataPageProvider) != null)
                  //         ? ref.watch(dataPageProvider)!.elementAt(index)
                  //         : getPaginateData(data).data.elementAt(index);

                  //     return CustomCardItem(
                  //       data: e,
                  //       width: 290,
                  //     );
                  //   },
                  // ),
                  ),
            ],
          );
  }
}
