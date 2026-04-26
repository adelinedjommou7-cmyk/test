import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

const desktopUserAgent =
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36";

/// Web link
const webWhatsappUrl =
    "https://storage.googleapis.com/portfolioseeva/Jeu%20-%20Les%20valeurs%20de%20position/index.html"; //"https://www.youtube.com/watch?v=_hdo2mpNP0Q";

class WebViews extends StatefulWidget {
  const WebViews({Key? key}) : super(key: key);

  @override
  State<WebViews> createState() => _WebViewsState();
}

class _WebViewsState extends State<WebViews> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "InAppBrowser",
        )),
        // drawer: myDrawer(context: context),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    await browser.openUrlRequest(
                      urlRequest: URLRequest(
                          url: WebUri(webWhatsappUrl)), //"https://flutter.dev"
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
                  },
                  child: Text("Open In-App Browser")),
              Container(height: 40),
              ElevatedButton(
                  onPressed: () async {
                    await InAppBrowser.openWithSystemBrowser(
                        url: WebUri(webWhatsappUrl));
                  },
                  child: Text("Open System Browser")),
            ])));
  }
}

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser(
      {int? windowId,
      UnmodifiableListView<UserScript>? initialUserScripts,
      PullToRefreshController? pullToRefreshController})
      : super(
          windowId: windowId,
          initialUserScripts: initialUserScripts,
          pullToRefreshController: pullToRefreshController,
        );

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
     print("\n\n$url onLoadStart\n\n");
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
  }

  @override
  Future<PermissionResponse> onPermissionRequest(request) async {
    return PermissionResponse(
        resources: request.resources, action: PermissionResponseAction.GRANT);
  }

  @override
  void onLoadError(url, code, message) {
     print("\n\n$url onLoadError\n\n");

    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  void onMainWindowWillClose() {
    close();
  }
}

//   final GlobalKey webViewKey = GlobalKey();

//   String url = '';
//   String title = '';
//   double progress = 0;
//   bool? isSecure;
//   InAppWebViewController? webViewController;

//   @override
//   void initState() {
//     super.initState();
//     url = webWhatsappUrl;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             FutureBuilder<bool>(
//               future: webViewController?.canGoBack() ?? Future.value(false),
//               builder: (context, snapshot) {
//                 final canGoBack = snapshot.hasData ? snapshot.data! : false;
//                 return IconButton(
//                   icon: const Icon(Icons.arrow_back_ios),
//                   onPressed: !canGoBack
//                       ? null
//                       : () {
//                           webViewController?.goBack();
//                         },
//                 );
//               },
//             ),
//             Expanded(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   overflow: TextOverflow.fade,
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     isSecure != null
//                         ? Icon(isSecure == true ? Icons.lock : Icons.lock_open,
//                             color: isSecure == true ? Colors.green : Colors.red,
//                             size: 12)
//                         : Container(),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Flexible(
//                         child: Text(
//                       url,
//                       style:
//                           const TextStyle(fontSize: 12, color: Colors.white70),
//                       overflow: TextOverflow.fade,
//                     )),
//                   ],
//                 )
//               ],
//             )),
//             FutureBuilder<bool>(
//               future: webViewController?.canGoForward() ?? Future.value(false),
//               builder: (context, snapshot) {
//                 final canGoForward = snapshot.hasData ? snapshot.data! : false;
//                 return IconButton(
//                   icon: const Icon(Icons.arrow_forward_ios),
//                   onPressed: !canGoForward
//                       ? null
//                       : () {
//                           webViewController?.goForward();
//                         },
//                 );
//               },
//             )
//           ],
//         ),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 if (url.isNotEmpty) {
//                   setState(() {
//                     // if (favoriteURLs.contains(url)) {
//                     //   favoriteURLs.remove(url);
//                     // } else {
//                     //   favoriteURLs.add(url);
//                     // }
//                   });
//                 }
//               },
//               icon: Icon(Icons.bookmark_add))
//         ],
//       ),
//       body: Column(children: <Widget>[
//         Expanded(
//             child: Stack(
//           children: [
//             InAppWebView(
//               key: webViewKey,
//               initialUrlRequest: URLRequest(url: Uri.parse(url)),
//               onWebViewCreated: (controller) async {
//                 webViewController = controller;
//                 if (!kIsWeb &&
//                     defaultTargetPlatform == TargetPlatform.android) {
//                   // await controller.startSafeBrowsing();
//                 }
//               },
//               onLoadStart: (controller, url) {
//                 if (url != null) {
//                   setState(() {
//                     this.url = url.toString();
//                     isSecure = urlIsSecure(url);
//                   });
//                 }
//               },
//               onLoadStop: (controller, url) async {
//                 if (url != null) {
//                   setState(() {
//                     this.url = url.toString();
//                   });
//                 }

//                 final sslCertificate = await controller.getCertificate();
//                 setState(() {
//                   isSecure = sslCertificate != null ||
//                       (url != null && urlIsSecure(url));
//                 });
//               },
//               onUpdateVisitedHistory: (controller, url, isReload) {
//                 if (url != null) {
//                   setState(() {
//                     this.url = url.toString();
//                   });
//                 }
//               },
//               onTitleChanged: (controller, title) {
//                 if (title != null) {
//                   setState(() {
//                     this.title = title;
//                   });
//                 }
//               },
//               onProgressChanged: (controller, progress) {
//                 setState(() {
//                   this.progress = progress / 100;
//                 });
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 final url = navigationAction.request.url;
//                 if (navigationAction.isForMainFrame &&
//                     url != null &&
//                     ![
//                       'http',
//                       'https',
//                       'file',
//                       'chrome',
//                       'data',
//                       'javascript',
//                       'about'
//                     ].contains(url.scheme)) {
//                   if (await canLaunchUrl(url)) {
//                     launchUrl(url);
//                     return NavigationActionPolicy.CANCEL;
//                   }
//                 }
//                 return NavigationActionPolicy.ALLOW;
//               },
//             ),
//             progress < 1.0
//                 ? LinearProgressIndicator(value: progress)
//                 : Container(),
//           ],
//         )),
//       ]),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.share),
//               onPressed: () {
//                 // Share.share(url, subject: title);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 webViewController?.reload();
//               },
//             ),
//             PopupMenuButton<int>(
//               onSelected: (item) => handleClick(item),
//               itemBuilder: (context) => [
//                 PopupMenuItem<int>(
//                     enabled: false,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: const [
//                             FlutterLogo(),
//                             Expanded(
//                                 child: Center(
//                               child: Text(
//                                 'Other options',
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             )),
//                           ],
//                         ),
//                         const Divider()
//                       ],
//                     )),
//                 PopupMenuItem<int>(
//                     value: 0,
//                     child: Row(
//                       children: const [
//                         Icon(Icons.open_in_browser),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text('Open in the Browser')
//                       ],
//                     )),
//                 PopupMenuItem<int>(
//                     value: 1,
//                     child: Row(
//                       children: const [
//                         Icon(Icons.clear_all),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text('Clear your browsing data')
//                       ],
//                     )),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void handleClick(int item) async {
//     switch (item) {
//       case 0:
//         await InAppBrowser.openWithSystemBrowser(url: Uri.parse(url));
//         break;
//       case 1:
//         await webViewController?.clearCache();
//         if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
//           // await webViewController?.clearHistory();
//         }
//         setState(() {});
//         break;
//     }
//   }

//   static bool urlIsSecure(Uri url) {
//     return (url.scheme == "https") || isLocalizedContent(url);
//   }

//   static bool isLocalizedContent(Uri url) {
//     return (url.scheme == "file" ||
//         url.scheme == "chrome" ||
//         url.scheme == "data" ||
//         url.scheme == "javascript" ||
//         url.scheme == "about");
//   }
// }





//   final TextEditingController _controller = TextEditingController(
//     text:
//         'https://support.google.com/googleplay/android-developer/answer/6320428',
//   );

//   HeadlessInAppWebView? headlessWebView;
//   String url = "";

//   @override
//   void initState() {
//     super.initState();

//     var url = !kIsWeb
//         ? Uri.parse("https://flutter.dev")
//         : Uri.parse("https://flutter.dev");

//     headlessWebView = HeadlessInAppWebView(
//       // webViewEnvironment: webViewEnvironment,
//       initialUrlRequest: URLRequest(url: url),
//       // initialSettings: InAppWebViewSettings(
//       //   isInspectable: kDebugMode,
//       // ),
//       onWebViewCreated: (controller) {
//         print('HeadlessInAppWebView created!');
//       },
//       onConsoleMessage: (controller, consoleMessage) {
//         print("CONSOLE MESSAGE: " + consoleMessage.message);
//       },
//       onLoadStart: (controller, url) async {
//         setState(() {
//           this.url = url.toString();
//         });
//       },
//       onLoadStop: (controller, url) async {
//         setState(() {
//           this.url = url.toString();
//         });
//       },
//       onUpdateVisitedHistory: (controller, url, isReload) {
//         setState(() {
//           this.url = url.toString();
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     headlessWebView?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text(
//           "HeadlessInAppWebView",
//         )),
//         body: SafeArea(
//             child: Column(children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(20.0),
//             child: Text(
//                 "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
//           ),
//           Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   await headlessWebView?.dispose();
//                   await headlessWebView?.run();
//                 },
//                 child: Text("Run HeadlessInAppWebView")),
//           ),
//           Container(
//             height: 10,
//           ),
//           Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   if (headlessWebView?.isRunning() ?? false) {
//                     await headlessWebView?.webViewController
//                         ?.evaluateJavascript(
//                             source: """console.log('Here is the message!');""");
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text(
//                           'HeadlessInAppWebView is not running. Click on "Run HeadlessInAppWebView"!'),
//                     ));
//                   }
//                 },
//                 child: Text("Send console.log message")),
//           ),
//           Container(
//             height: 10,
//           ),
//           Center(
//             child: ElevatedButton(
//                 onPressed: () {
//                   headlessWebView?.dispose();
//                   setState(() {
//                     this.url = "";
//                   });
//                 },
//                 child: Text("Dispose HeadlessInAppWebView")),
//           )
//         ])));
//   }
// }
