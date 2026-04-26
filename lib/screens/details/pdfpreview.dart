import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:example/main.dart';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/main_home.dart';
import 'package:example/screens/widget/custom_pagination_option.dart';
import 'package:example/theme.dart';
import 'package:example/widgets/changelog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class PdfPreviewPage extends ConsumerStatefulWidget {
  PdfPreviewPage({
    super.key,
    required this.path,
    required this.data,
    this.isOnline = false,
  });

  Ressources data;
  String path;
  bool isOnline;

  @override
  ConsumerState<PdfPreviewPage> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<PdfPreviewPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Completer<PDFViewController> controller;
  int? currentPage = 0;
  String errorMessage = '';
  bool isDownload = false;
  bool isReady = false;
  int? pages = 0;
  String pathPDF = '';
  late PdfViewerController pdfViewerController;
  late PdfTextSearchResult searchResult;

  late bool _canShowPdf;
  late Color _color;
  late Color _disabledColor;

  /// Ensure the entry history of Text search.
  LocalHistoryEntry? _historyEntry;

  bool _isInitialBookmarkShown = false;
  late bool _isLight;
  bool _isPdfLoaded = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  double _sampleWidth = 0, _sampleHeight = 0;
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  late bool _useMaterial3;
  bool isSearchInitiated = false;

  @override
  void initState() {
    setState(() {
      pathPDF = widget.path;
    });
    print('isOnline : ${widget.isOnline}') ;
    print('URL: ${localhostServer.documentRoot}${widget.data.followLink!}');
    animationController = AnimationController(
        duration: const Duration(milliseconds: 650),
        vsync: this,
        reverseDuration: const Duration(milliseconds: 400));
    pdfViewerController = PdfViewerController();
    controller = Completer<PDFViewController>();
    searchResult = PdfTextSearchResult();
    Future<dynamic>.delayed(const Duration(milliseconds: 600), () {
      if (super.mounted) {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.requestFocus(FocusNode());
        }
      }
    });
    super.initState();
    _canShowPdf = false;
    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  double zoom = 1;

  FocusNode? focusNode;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode?.dispose();
    searchResult.dispose();
    pdfViewerController.removeListener(() {});
    super.dispose();
  }

  ///Clear the text search result
  void clearSearch() {
    isSearchInitiated = false;
    searchResult.clear();
  }

  Uint8List convertListToInt8List(List<int> dataBytes) {
    return Uint8List.fromList(dataBytes);
  }

  showLoading(String text) {
    showDialog(
      context: context,
      barrierLabel: text,
      barrierDismissible: true,
      builder: (context) => Changelog(
        title: text,
      ),
    );
  }

  double convertIntToDouble(int integerValue) {
    switch (integerValue) {
      case 75:
        return 1;
      case 100:
        return 2;
      case 125:
        return 3;
      default:
        return double.parse(integerValue.toString());
    }
  }

  String convertDoubleToString(num integerValue) {
    switch (integerValue) {
      case 1:
        return '75%';
      case 2:
        return '100%';
      case 3:
        return '125%';
      default:
        return '75%';
    }
  }

  /// Save document
  Future<void> _saveDocument(
      List<int> dataBytes, String message, String fileName) async {
    showLoading("Téléchargement du document...");
    String? outputFile = await FilePicker.platform.saveFile(
      bytes: convertListToInt8List(dataBytes),
      initialDirectory:
          await getDownloadsDirectory().then((value) => value?.path),
      dialogTitle:
          'Choisir l\'emplacement de l\'enregistrement de la ressource Seeva',
      allowedExtensions: ['pdf'],
      type: FileType.custom,
      lockParentWindow: true,
      fileName: widget.data.title!.replaceAll(" ", '-'),
    );
    if (outputFile != null) {
      // append .pdf extension if not already provided
      if (!outputFile.endsWith('.pdf')) {
        outputFile += '.pdf';
      }
      final File file = File(outputFile);
      await file.writeAsBytes(dataBytes).then((value) {
        Navigator.pop(context);
      });
      _showDialog(message + outputFile, outputFile);
    } else {
      Navigator.pop(context);
    }
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
                  await OpenFilex.open(outputFile);
                  Navigator.of(context).pop();
                },
                child: const Text('D\'accord'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final appTheme = ref.watch(themeProvider);
    final localizations = FluentLocalizations.of(context);
    const spacer = SizedBox(height: 10.0);
    // const biggerSpacer = SizedBox(height: 40.0);
    final theme = FluentTheme.of(context);
    // final height = MediaQuery.of(context).size.height * 0.6;

    if (_sampleHeight != MediaQuery.of(context).size.height ||
        _sampleWidth != MediaQuery.of(context).size.width) {
      _sampleWidth = MediaQuery.of(context).size.width;
      _sampleHeight = MediaQuery.of(context).size.height;
      _canShowPdf = false;
    }

    if (isDesktop && _isPdfLoaded && !_isInitialBookmarkShown) {
      Future<dynamic>.delayed(const Duration(milliseconds: 2000))
          .then((dynamic value) {
        _pdfViewerKey.currentState?.openBookmarkView();
      });
      _isInitialBookmarkShown = true;
    }

    return Container(
      color: theme.brightness == Brightness.light ? Colors.white : Colors.grey,
      child: ScaffoldPage(
        header: PageHeader(
          title: Padding(
            padding: const EdgeInsetsDirectional.only(end: 2.0, bottom: 15),
            child: Text(
              widget.data.title.toString(),
              style: FluentTheme.of(context)
                  .typography
                  .subtitle
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          leading: const m.BackButton(),        
            // leading: () {
          //   onPressed() {
          //     Navigator.pop(context);
          //     setState(() {});
          //   }

          //   return NavigationPaneTheme(
          //    data: NavigationPaneTheme.of(context).merge(
          //     NavigationPaneThemeData(
          //       unselectedIconColor: WidgetStateProperty.resolveWith((states) {
          //         if (states.isDisabled) {
          //           return ButtonThemeData.buttonColor(context, states);
          //         }
          //         return ButtonThemeData.uncheckedInputColor(
          //           FluentTheme.of(context),
          //           states,
          //         ).basedOnLuminance();
          //       }),
          //     ),
          //   ),
          //     child: Builder(
          //       builder: (context) => Padding(
          //         padding:
          //             const EdgeInsetsDirectional.only(end: 2.0, bottom: 10),
          //         child: PaneItem(
          //           icon:
          //               const Center(child: Icon(FluentIcons.back, size: 12.0)),
          //           title: Text(localizations.backButtonTooltip),
          //           body: const SizedBox.shrink(),
          //           enabled: true,
          //         ).build(
          //           context: context,
          //           selected: false,
          //           onPressed: onPressed,
          //           itemIndex: 0,
          //           displayMode: PaneDisplayMode.compact,
          //         ),
          //       ),
          //     ),
          //   );
          // }(),
          commandBar: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const SizedBox(
                width: 4,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(end: 2.0, bottom: 20),
                  child: ToggleSwitch(
                    content: const Text('Theme'),
                    checked: FluentTheme.of(context).brightness == Brightness.dark,
                    onChanged: (v) {
                      if (v) {
                        appTheme.mode = ThemeMode.dark;
                      } else {
                        appTheme.mode = ThemeMode.light;
                      }
                    },
                  ),
                ),
              ),
              if (kIsWeb)
                const Padding(
                  padding: EdgeInsetsDirectional.only(end: 4.0, bottom: 20),
                  child: WindowButtons(),
                ),
            ]),
          ),
        ),
        content: FutureBuilder(
            future: Future<dynamic>.delayed(const Duration(milliseconds: 200))
                .then((dynamic value) {
              _canShowPdf = true;
            }),
            builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
              if (_canShowPdf) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 200.0,
                                child: Tooltip(
                                  message: 'Rechercher un mot,nom...',
                                  child: TextBox(
                                    // controller: _searchController,
                                    suffix: const Icon(FluentIcons.search),
                                    placeholder: 'Rechercher un mot',
                                    onSubmitted: (value) => setState(() {
                                      // if (value.length >= 2) {
                                      isSearchInitiated = true;
                                      searchResult = pdfViewerController
                                          .searchText(value,
                                              searchOption: TextSearchOption
                                                  .caseSensitive);
                                      searchResult.addListener(() {
                                        if (searchResult.hasResult) {
                                          // &&
                                          // searchResult.isSearchCompleted
                                          setState(() {});
                                          print(
                                              'Total instance count: ${searchResult.totalInstanceCount}');
                                        }
                                      });
                                      // }
                                    }),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !searchResult.hasResult,
                                child: Row(
                                  children: [
                                    Text(
                                      ' Page(s) ${pdfViewerController.pageCount}',
                                      style: FluentTheme.of(context)
                                          .typography
                                          .title
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        m.Icons.keyboard_arrow_up,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        pdfViewerController.previousPage();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        m.Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        pdfViewerController.nextPage();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Row(
                              children: [
                                Visibility(
                                  visible: !searchResult.isSearchCompleted &&
                                      isSearchInitiated,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: m.CircularProgressIndicator(
                                        color: m.Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: searchResult.hasResult,
                                  child: Text(
                                    'Resultat : ${searchResult.currentInstanceIndex} sur ${searchResult.totalInstanceCount}',
                                    style: FluentTheme.of(context)
                                        .typography
                                        .title
                                        ?.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(
                                  width: (5),
                                ),
                                Visibility(
                                  visible: searchResult.hasResult,
                                  child: IconButton(
                                    icon: const Icon(
                                      m.Icons
                                          .navigate_before, //keyboard_arrow_up,
                                      // color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      searchResult.previousInstance();
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: searchResult.hasResult,
                                  child: IconButton(
                                    icon: const Icon(
                                      m.Icons
                                          .navigate_next, //keyboard_arrow_down,
                                      // color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // searchResult.nextInstance();
                                      searchResult.nextInstance();
                                      // if (searchResult.currentInstanceIndex ==
                                      //         searchResult.totalInstanceCount &&
                                      //     searchResult.isSearchCompleted) {
                                      //   print('No more occurrences found.');
                                      // }

                                      setState(() {
                                        if (searchResult.currentInstanceIndex ==
                                                searchResult
                                                    .totalInstanceCount &&
                                            searchResult.currentInstanceIndex !=
                                                0 &&
                                            searchResult.totalInstanceCount !=
                                                0 &&
                                            searchResult.isSearchCompleted) {
                                          _showSearchAlertDialog(context);
                                        } else {
                                          pdfViewerController.clearSelection();
                                          searchResult.nextInstance();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: (5),
                                ),
                                Visibility(
                                  visible: searchResult.hasResult,
                                  child: IconButton(
                                    icon: const Icon(
                                      m.Icons.clear,
                                      // color: Colors.red.withOpacity(0.5),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isSearchInitiated = false;
                                        searchResult.clear();
                                        pdfViewerController.clearSelection();
                                        focusNode!.requestFocus();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: (5),
                                ),
                                CustomPaginationOptions(
                                  item: convertDoubleToString(zoom),
                                  limitPerPage: 10,
                                  backgroundColor: Colors.grey,
                                  pageLimitOptions:
                                      ref.watch(zoomLimitOptionsProvider),
                                  onPageLimitChanged: (p) {
                                    setState(() {
                                      zoom = convertIntToDouble(p!);
                                      pdfViewerController.zoomLevel =
                                          convertIntToDouble(p);

                                      // pdfViewerController.zoomLevel = 0.25;
                                    });
                                  },
                                  text: 'Zoom',
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      final List<int> formDataBytes =
                                          await pdfViewerController
                                              .saveDocument();
                                      _saveDocument(
                                          formDataBytes,
                                          'Le fichier exporté a été enregistré à l\'emplacement ',
                                          'form.pdf');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all((5)),
                                      decoration: BoxDecoration(
                                          //color: Colors.black.withOpacity(0.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular((8))),
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.1))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Télécharger',
                                            style: FluentTheme.of(context)
                                                .typography
                                                .title
                                                ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                          spacer,
                                          const Icon(
                                            m.Icons.file_download_outlined,
                                            // color: Theme.of(context).primaryColor,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: (10),
                    ),
                    Expanded(
                      child: SfPdfViewerTheme(
                        data: SfPdfViewerThemeData(),
                        child: widget.isOnline
                            ? SfPdfViewer.network(
                                widget.data.followLink!,
                                controller: pdfViewerController,
                                undoController: _undoHistoryController,
                                pageSpacing: 12,
                                // currentSearchTextHighlightColor: Colors.blue,
                                // otherSearchTextHighlightColor: Colors.yellow,
                                canShowScrollHead: true,
                                initialZoomLevel: 0.50,
                                onDocumentLoaded:
                                    (PdfDocumentLoadedDetails details) {
                                  setState(() {
                                    _isPdfLoaded = true;
                                    _isInitialBookmarkShown = false;
                                  });
                                },
                                onZoomLevelChanged: (PdfZoomDetails details) {
                                  print(
                                      'newZoomLevel: ${details.newZoomLevel}');
                                },
                              )
                            : SfPdfViewer.file(
                                File(localhostServer.documentRoot +
                                    widget.data.followLink!),
                                controller: pdfViewerController,
                                undoController: _undoHistoryController,
                                // currentSearchTextHighlightColor: Colors.blue,
                                // otherSearchTextHighlightColor: Colors.yellow,
                                canShowScrollHead: true,
                                initialZoomLevel: 0.50,
                                onDocumentLoaded:
                                    (PdfDocumentLoadedDetails details) {
                                  setState(() {
                                    _isPdfLoaded = true;
                                    _isInitialBookmarkShown = false;
                                  });
                                },
                                onZoomLevelChanged: (PdfZoomDetails details) {
                                  print(
                                      'newZoomLevel: ${details.newZoomLevel}');
                                },
                              ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  color: SfPdfViewerTheme.of(context)!.backgroundColor,
                );
              }
            }),
      ),
    );
  }

  ///Display the Alert dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return ContentDialog(
            title: const Text('Résultat recherche'),
            content: const SizedBox(
              width: 328.0,
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Text(
                      'Aucune autre occurrence n\'a été trouvée. Souhaitez-vous poursuivre la recherche depuis le début ?'),
                ),
              ),
            ),
            actions: <Widget>[
              FilledButton(
                onPressed: () async {
                  setState(() {
                    searchResult.nextInstance();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Oui'),
              ),
              FilledButton(
                onPressed: () async {
                  setState(() {
                    isSearchInitiated = false;
                    searchResult.clear();
                    pdfViewerController.clearSelection();
                    focusNode!.requestFocus();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Non'),
              )
            ],
          );
        });
  }
}
