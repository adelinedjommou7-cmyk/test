// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:math';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/home.dart';
import 'package:example/screens/ressources/core/domaine/ressources_item_page.dart';
import 'package:example/screens/widget/custom_pagination.dart';
import 'package:example/screens/widget/custom_pagination_option.dart';
import 'package:example/widgets/custom_gridview.dart';
import 'package:example/widgets/empty_page.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SearchActivityPage extends ConsumerStatefulWidget {
  const SearchActivityPage(
      {super.key,
      this.title = 'Activités en ligne',
      this.typeId = '6',
      required this.pageController,
      this.data});
  final List<Ressources>? data;
  final String typeId;
  final String title;
  final PageController pageController;

  @override
  _SearchActivityPageState createState() => _SearchActivityPageState();
}

class _SearchActivityPageState extends ConsumerState<SearchActivityPage>
    with TickerProviderStateMixin {
  String filterText = '';

  List<Ressources> displayElements = [];
  List<Ressources> display = [];

  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  int pageLimit = 10;
  List<int> pageLimitOptions = [10, 25, 50];
  int totalDataCount = 100;
  dynamic sampleData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // displayElements = widget.data!;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ScrollController? controller;

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
    // ignore: invalid_use_of_protected_member
    final state = ref.read(allActivityNotifierProvider.notifier).state;

    return ScaffoldPage(
        header: PageHeader(
          leading: IconButton(
              onPressed: () {
                widget.pageController.jumpToPage(0);
              },
              icon: const Icon(
                FluentIcons.back,
                size: 12.0,
              )),
          title: const Text(
            'Rechercher une activité',
            style: TextStyle(fontSize: 16),
          ),
          commandBar: SizedBox(
            width: 240.0,
            child: Tooltip(
              message: 'Recherche par title, categorie, niveau...',
              child: TextBox(
                // controller: _searchController,
                suffix: const Icon(FluentIcons.search),
                placeholder: 'Rechercher ici...',
                onChanged: (value) => setState(() {
                  setState(() {
                    ref
                        .read(allActivityNotifierProvider.notifier)
                        .searchRessource(
                          // typeId: widget.typeId,
                          searchItem: value,
                          // niveau:
                          //     convertLevel(ref.watch(downloadProvider).niveauStat)
                        );
                  });
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
        ));
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
              )),
            ],
          );
  }
}
