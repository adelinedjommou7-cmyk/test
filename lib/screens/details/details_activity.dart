// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:example/main.dart';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/details/pdfpreview.dart';
import 'package:example/screens/details/web_view_activity.dart';
import 'package:example/screens/niveau/widget/app_style.dart';
import 'package:example/screens/ressources/presentation/web.dart';
import 'package:example/screens/theming/icons.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/page.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

class DetailsActivity extends ConsumerStatefulWidget {
  const DetailsActivity({super.key, required this.data});
  final Ressources data;

  @override
  // ignore: library_private_types_in_public_api
  _DetailsActivityState createState() => _DetailsActivityState();
}

// final indexPage = StateProvider<int>((ref) => 0);

class _DetailsActivityState extends ConsumerState<DetailsActivity>
    with WindowListener, PageMixin {
  late final MyInAppBrowser browser;

  late Ressources data;
  bool hyperlinkDisabled = false;
  @override
  void initState() {
    windowManager.addListener(this);
    data = widget.data;
    super.initState();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
      // print(localhostServer.documentRoot);
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

      browser =
          MyInAppBrowser(pullToRefreshController: pullToRefreshController);
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {}
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     assert(debugCheckHasMediaQuery(context));
    final isConnectedAsyncValue = ref.watch(isConnectedProvider);
    final localizations = FluentLocalizations.of(context);
    const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);
    final theme = FluentTheme.of(context);
    final height = MediaQuery.of(context).size.height * 0.6;
 
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // MediaQuery.of(context).size.width >= 600
      //         ? _renderLargeScreenPagination()
      //         : _renderSmallScreenPagination(),
      return Container(
        color: theme.brightness == Brightness.light ? Colors.white : Colors.grey,
        child: ScaffoldPage.scrollable(
          header: PageHeader(
            // padding: 20,
            title: Text('DetailsActivity',
                style: FluentTheme.of(context).typography.subtitle),
            leading:const m.BackButton(),
            
            //  () {
            //   onPressed() {
            //     Navigator.pop(context);
            //     setState(() {});
            //   }

            //   return NavigationPaneTheme(
            //     data: NavigationPaneTheme.of(context).merge(
            //       NavigationPaneThemeData(
            //         unselectedIconColor: WidgetStateProperty.resolveWith((states) {
            //           if (states.isDisabled) {
            //             return ButtonThemeData.buttonColor(context, states);
            //           }
            //           return ButtonThemeData.uncheckedInputColor(
            //             FluentTheme.of(context),
            //             states,
            //           ).basedOnLuminance();
            //         }),
            //       ),
            //     ),
            //     child: Builder(
            //       builder: (context) => PaneItem(
            //         icon:
            //             const Center(child: Icon(FluentIcons.back, size: 12.0)),
            //         title: Text(localizations.backButtonTooltip),
            //         body: const SizedBox.shrink(),
            //         enabled: true,
            //       ).build(
            //         context: context,
            //         selected: false,
            //         onPressed: onPressed,
            //         itemIndex: 0,
            //         displayMode: PaneDisplayMode.compact,
            //       ),
            //     ),
            //   );
            // }(),
            
            commandBar:
                const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // Align(
              //   alignment: AlignmentDirectional.centerEnd,
              //   child: Padding(
              //     padding:
              //         const EdgeInsetsDirectional.only(end: 8.0, bottom: 20),
              //     child: ToggleSwitch(
              //       content: const Text('Theme'),
              //       checked: FluentTheme.of(context).brightness.isDark,
              //       onChanged: (v) {
              //         if (v) {
              //           appTheme.mode = ThemeMode.dark;
              //         } else {
              //           appTheme.mode = ThemeMode.light;
              //         }
              //       },
              //     ),
              //   ),
              // ),
              if (!kIsWeb)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.0, bottom: 20),
                  child: WindowButtons(),
                ),
            ]),
          ),
          children: [
            Text(
              '${data.title}',
              style: FluentTheme.of(context)
                  .typography
                  .title
                  ?.copyWith(fontSize: 16),
            ),
            spacer,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Categories ',
                    style: FluentTheme.of(context)
                        .typography
                        .subtitle
                        ?.copyWith(fontSize: 14),
                    children: <TextSpan>[
                      if (data.type?.isNotEmpty ?? false)
                        ...data.type!.map(
                          (e) => TextSpan(
                              text: e.title,
                              style: FluentTheme.of(context)
                                  .typography
                                  .subtitle
                                  ?.copyWith(
                                      color: kSecondaryColor, fontSize: 12),
                              children: [
                                if (e.id !=
                                    data.type
                                        ?.elementAt(data.type!.length - 1)
                                        .id)
                                  TextSpan(
                                      text: ', ',
                                      style: FluentTheme.of(context)
                                          .typography
                                          .subtitle
                                          ?.copyWith(
                                              color: kSecondaryColor,
                                              fontSize: 12)),
                              ]),
                        ),
                    ],
                  ),
                ),
                LikeButton(
                  size: 40.0,
                  circleColor: const CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      CashHelper.favExist(data)
                          ? m.Icons.favorite
                          : m.Icons.favorite_border,
                      color: isLiked
                          ? m.Colors.deepPurpleAccent
                          : CashHelper.favExist(data)
                              ? Colors.red
                              : Colors.grey,
                      size: 30.0,
                    );
                  },
                  likeCount: null,
                  onTap: !CashHelper.favExist(data)
                      ? (isLiked) async {
                          final added = await CashHelper.addFav(data);
                          setState(() {});
                          if (added) {
                            // ignore: use_build_context_synchronously
                            showCopiedSnackbar(context,
                                "${data.title} a bien été ajouté aux favoris.",
                                severity: InfoBarSeverity.success);
                            ref.watch(havorisProvider).getRessourcesList();
                          } else {
                            // showCopiedSnackbar(context,
                            //     "${data.title} a bien été retiré des favoris.");
                          }
                          return !isLiked;
                        }
                      : (isLiked) async {
                          await CashHelper.removeFav(data);
                          setState(() {});
                          // ignore: use_build_context_synchronously
                          showCopiedSnackbar(context,
                              "${data.title} a bien été retiré des favoris.",
                              severity: InfoBarSeverity.success);
                          ref.watch(havorisProvider).getRessourcesList();
                          return !isLiked;
                        },
                ),
              ],
            ),
            biggerSpacer,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 20, right: 20),
                // color: Colors.red,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          color: Colors.grey.withOpacity(0.03),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  (data.image?.isEmpty ?? true)
                                      ? imgPlaceHolder
                                      : data.image!
                                          .replaceAll(RegExp(r'é'), 'e')
                                          .replaceAll(RegExp(r'è'), 'e'),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Stack(
                            children: [
                              m.Positioned(
                                top: 35,
                                left: 8,
                                right: 8,
                                bottom: height * 0.35,
                                child: Container(
                                  // color: Colors.orange,
                                  child: description(
                                    content: Text(
                                      data.description ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              m.Positioned(
                                top: height * 0.5,
                                bottom: 8,
                                left: 8,
                                right: height * 0.5,
                                child: Link(
                                  uri: Uri.parse(data.followLink.toString()),
                                  builder: (context, open) {
                                    final isConnect =
                                        isConnectedAsyncValue.value;
                                    return Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: FilledButton(
                                        onPressed: isPDFPath(data.followLink ?? '')
                                            ? () async {
                                                openFile(
                                                    url: (isConnect ?? false)
                                                        ? data.followLink ?? ''
                                                        : data.localLink ?? '');
                                              }
                                            : () async {
                                            String? getBestLink() {
                                              final hasFollow = data.followLink?.isNotEmpty == true;
                                              final hasLocal = data.localLink?.isNotEmpty == true;

                                              if (isConnect == true) {
                                                if (hasFollow) return data.followLink;
                                                if (hasLocal) return data.localLink;
                                              } else {
                                                if (hasLocal) return data.localLink;
                                                if (hasFollow) return data.followLink;
                                              }

                                              return null;
                                            }

                                            await openUrlRequest(url: getBestLink() ?? '');
                                                // await openUrlRequest(
                                                //     url: (isConnect ?? false)
                                                //         ? data.followLink != null ? data.followLink ?? data.localLink ?? '' : data.localLink ?? data.followLink ?? ''
                                                //         : data.localLink ?? data.followLink ?? '');
                                              },
                                        child: Semantics(
                                            link: true,
                                            child: Text(getTitle(data)
                                                // isPDFPath(data.followLink!)
                                                //     ? 'Consulter'
                                                //     : 'Lancer le jeu')
                                                )),
                                      ),
                                      // HyperlinkButton(
                                      //   onPressed: hyperlinkDisabled ? null : open,
                                      //   child: Semantics(
                                      //     link: true,
                                      //     child: Text('Fluent UI homepage'),
                                      //   ),
                                      // ),
                                    );
                                  },
                                ),
                              ),
                              m.Positioned(
                                top: height * 0.75,
                                bottom: 5,
                                left: height * 0.35,
                                right: 6,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Etiquettes'),
                                      spacer,
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 6.0,
                                        children: <Widget>[
                                          ...(data.niveau ?? []).map(
                                            (e) => Card(
                                              padding: const EdgeInsets.all(8),
                                              child: SizedBox(
                                                height: 15,
                                                child: Text(
                                                  e,
                                                  style: FluentTheme.of(context)
                                                      .typography
                                                      .subtitle
                                                      ?.copyWith(
                                                          color:
                                                              kSecondaryColor,
                                                          fontSize: 11),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            spacer,
          ],
        ),
      );
    });
  
  }

  String getTitle(Ressources data) {
    final isGame = data.type?.any((element) => element.id == '6') ?? false;
    return isGame ? 'Lancer le jeu' : 'Consulter';
  }

  openFile({required String url}) async {
    SystemSound.play(
        Platform.isMacOS ? SystemSoundType.alert : SystemSoundType.click);
    const transitionDuration = Duration(milliseconds: 100);
    if (url.isEmpty) {
      showCopiedSnackbar(context,
          "Impossible de lancer cette activité car le fichier source ne pointe pas à la bonne adresse! ",
          severity: InfoBarSeverity.error);
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          reverseTransitionDuration: transitionDuration,
          pageBuilder: (_, animation, ___) {
            windowManager.maximize();
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
              return PdfPreviewPage(
                  isOnline: isURL(data.followLink ?? ''),
                  path: data.followLink ?? '',
                  data: data);
            } else {
              return MyWebApp(
                  data: data, path: CashHelper.getData(key: 'html').toString());
            }
          },
        ),
      );
    }
  }

  openUrlRequest({String url = 'P.25. Les graphes/'}) async {
    SystemSound.play(
        Platform.isMacOS ? SystemSoundType.alert : SystemSoundType.click);
    String? BaseUrl;
    final isConnect = ref.watch(isConnectedProvider).value ?? false;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
      if (url.isEmpty) {
        showCopiedSnackbar(context,
            "Impossible de lancer cette activité car le fichier source ne pointe pas à la bonne adresse! ",
            severity: InfoBarSeverity.error);
      } else {
        if (isConnect && url.contains('http')) {
          BaseUrl = url;
          print('BaseUrl : $BaseUrl');
        } else {
          BaseUrl = 'http://localhost:8080/$url';
          print('BaseUrl : $BaseUrl');
        }

        await browser.openUrlRequest(
          urlRequest: URLRequest(url: WebUri(BaseUrl)), //webWhatsappUrl
          settings: InAppBrowserClassSettings(
            browserSettings: InAppBrowserSettings(
                toolbarTopBackgroundColor: Colors.blue,
                presentationStyle: ModalPresentationStyle.POPOVER),
            webViewSettings: InAppWebViewSettings(
              isInspectable: kDebugMode,
              useShouldOverrideUrlLoading: true,
              useOnLoadResource: true,
            ),
          ),
        );
      }
    } else {
      const transitionDuration = Duration(milliseconds: 100);
      if (url.isEmpty) {
        showCopiedSnackbar(context,
            "Impossible de lancer cette activité car le fichier source ne pointe pas à la bonne adresse! ",
            severity: InfoBarSeverity.error);
      } else {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: transitionDuration,
            reverseTransitionDuration: transitionDuration,
            pageBuilder: (_, animation, ___) {
              windowManager.maximize();
              return MyWebApp(data: data);
            },
          ),
        );
      }
    }
  }
}
