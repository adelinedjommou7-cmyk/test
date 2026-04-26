import 'dart:math';

import 'package:example/helpers/responsive_helper.dart';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/home.dart';
import 'package:example/screens/ressources/core/domaine/ressources_item_page.dart';
import 'package:example/screens/widget/custom_pagination.dart';
import 'package:example/screens/widget/custom_pagination_option.dart';
import 'package:example/widgets/custom_gridview.dart';
import 'package:example/widgets/empty_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as m;
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

class HistoriqueActivityPage extends ConsumerStatefulWidget {
  const HistoriqueActivityPage(
      {super.key,
      this.title = 'Activités en ligne',
      this.typeId = '3',
      this.data});
  final List<Ressources>? data;
  final String typeId;
  final String title;
  @override
  _HistoriqueActivityPageState createState() => _HistoriqueActivityPageState();
}

class _HistoriqueActivityPageState extends ConsumerState<HistoriqueActivityPage>
    with TickerProviderStateMixin {
  String filterText = '';

  List<Ressources> displayElements = [];
  List<Ressources> display = [];

  final TextEditingController _searchController = TextEditingController();
  late List<Ressources> _filteredActivities;

  @override
  void initState() {
    super.initState();
    // Future.microtask(() => ref
    //     .watch(ressourcesNotifierProvider.notifier)
    //     .fetchHistorique(typeId: widget.typeId));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _filterActivities();
      displayElements = widget.data!;
    });
    _searchController.addListener(_filterActivities);
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
    // ref
    //     .watch(ressourcesNotifierProvider.notifier)
    //     .fetchRessource(typeId: widget.typeId);
    final state = ref.read(historyNotifierProvider.notifier).state;
    final ResponsiveHelper _respHelper = ResponsiveHelper(context: context);

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
                  ref.read(historyNotifierProvider.notifier).searchRessource(
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
        ));
  }

  Widget customItem(List<Ressources>? data) {
    return data!.isEmpty
        ? const CustomEmptyPage()
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
