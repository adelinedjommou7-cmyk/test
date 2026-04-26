import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:example/audio/data/audio_player_service_impl.dart';
import 'package:example/audio/services/audio_player_service.dart';
import 'package:example/main.dart';
import 'package:example/models/ressources.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/details/details_activity.dart';
import 'package:example/screens/main_home.dart';
import 'package:example/screens/niveau/widget/app_style.dart';
import 'package:example/screens/theming/icons.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/hovered_card.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/link.dart';
import '../../../widgets/changelog.dart';
import '../../../widgets/page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.pageController});
  final PageController pageController;

  @override
  _HomePageState createState() => _HomePageState();
}

// bool _initialUriIsHandled = false;

class _HomePageState extends ConsumerState<HomePage>
    with PageMixin, WidgetsBindingObserver {
  bool isListening = false;
  String? address;
  int? port;
  bool selected = true;
  String? comboboxValue;
  final flyoutController = FlyoutController();

  @override
  void initState() {
    super.initState();
    // _initServer();
    // Run the command
    runShell();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> runShell() async {
    // Directory appDir = await getApplicationSupportDirectory();
    // print(
    //     'Chemin du dossier d\'installation de l\'application : ${appDir.path}');
    // final command = 'ls';
    // final arguments = ['-l', 'seeva_education'];
    // ProcessCmd cmd = ProcessCmd(command, arguments, runInShell: false);
    // var result = await runCmd(cmd);
    // print('output: "${result.outText}" exitCode: ${result.exitCode}');

    // print(await prompt('Enter your name'));
    // print(await promptConfirm('Action'));
    // await promptTerminate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _initServer() async {
    // final server = LocalAssetsServer(
    //   address: InternetAddress.loopbackIPv4,
    //   assetsBasePath: 'assets',
    //   port: 8082,
    //   rootDir: Directory(
    //       '/Users/paysikadevteam/seeva/seeva_education/assets/jeux/Jeu de maths- À la ferme'),
    //   logger: const DebugLogger(),
    // );

    // final address = await server.serve();

    // setState(() {
    //   this.address = address.address;
    //   port = server.boundPort!;
    //   isListening = true;
    //   // statusText = "Starting server on Port : 8080";
    //   print("$address,$port");
    // });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    final state = ref.read(niveauNotifierProvider.notifier).state;
    final theme = FluentTheme.of(context);
    final provider = ref.watch(downloadProvider);
    // final appTheme = ref.watch(themeProvider);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        leading: Image.asset(
          'assets/icons/icon.png',
          width: 200,
          height: 100,
          // style: FlutterLogoStyle.horizontal,
          // size: 80.0,
          // textColor: Colors.white,
          // duration: Duration.zero,
        ),
        title: const Text(''),
        //const Text('Fluent UI for Flutter Showcase App'),
        commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Semantics(
            link: true,
            child: Tooltip(
              message: 'Rechercher une activité',
              child: IconButton(
                icon: const Icon(FluentIcons.search_art64, size: 24.0),
                onPressed: () {
                  widget.pageController.jumpToPage(3);
                },
              ),
            ),
          ),
          // Link(
          //   uri: Uri.parse('https://github.com/bdlukaa/fluent_ui'),
          //   builder: (context, open) => Semantics(
          //     link: true,
          //     child: Tooltip(
          //       message: 'Source code',
          //       child: IconButton(
          //         icon: const Icon(FluentIcons.open_source, size: 24.0),
          //         onPressed: open,
          //       ),
          //     ),
          //   ),
          // ),
        ]),
      ),
      children: [
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: '',
                      style: FluentTheme.of(context)
                          .typography
                          .subtitle
                          ?.copyWith(fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Accueil',
                            style: FluentTheme.of(context)
                                .typography
                                .subtitle
                                ?.copyWith(fontSize: 13),
                            children: [
                              TextSpan(
                                  text:
                                      ' >${convertLevelTitle(provider.niveau)}',
                                  style: FluentTheme.of(context)
                                      .typography
                                      .subtitle
                                      ?.copyWith(fontSize: 13)),
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
              HyperlinkButton(
                onPressed: () {
                  final index = CashHelper.getData(key: 'indexNiveau') ?? 0;
                  setState(() {
                    ref.read(indexPage.notifier).update((state) => state = 0);
                    ref
                        .read(isCloneHome.notifier)
                        .update((state) => state = true);
                    ref
                        .read(niveauNotifierProvider.notifier)
                        .fetchRessource(niveau: convertLevel(index.toString()));
                    widget.pageController.jumpToPage(1);
                  });
                },
                child: Text(
                  "Voir plus",
                  style: FluentTheme.of(context)
                      .typography
                      .subtitle
                      ?.copyWith(fontSize: 13),
                ),
              )
            ]),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 270,
            child: state.map(
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
        const SizedBox(height: 22.0),
        IconButton(
          onPressed: () {
            // showDialog(
            //   context: context,
            //   barrierDismissible: true,
            //   builder: (context) => Changelog(),
            // );
          },
          icon: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seeva Education 4.0.0',
                style: theme.typography.body
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
              Text('Mai, 2024', style: theme.typography.caption),
              Text(
                'Des ressources numérique et des contenus de qualité pour soutenir l’apprentissage de chaque élève.',
                style: theme.typography.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22.0),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Favoris', style: theme.typography.bodyStrong),
                  const SizedBox(width: 4.0),
                  const Icon(FluentIcons.heart_fill, size: 16.0),
                ],
              ),
              HyperlinkButton(
                onPressed: () {
                  setState(() {
                    ref.read(indexPage.notifier).update((state) => state = 0);
                    ref
                        .read(isCloneHome.notifier)
                        .update((state) => state = true);
                    widget.pageController.jumpToPage(2);
                  });
                },
                child: Text(
                  "Voir plus",
                  style: FluentTheme.of(context)
                      .typography
                      .subtitle
                      ?.copyWith(fontSize: 13),
                ),
              )
            ]),
        const SizedBox(height: 12.0),
        // CashHelper.favExist(data), CashHelper.getRessourcesList()
        SizedBox(
            height: 270, child: customItem(ref.watch(havorisProvider).getList)),
      ],
    );
  }

  Widget customItem(List<Ressources>? data) {
    return data!.isEmpty
        ? Center(
            child: Image.asset(
              "assets/gifs/GIF 5.gif",
              // controller: _controller,
              // height: MediaQuery.of(context).size.height,
              // width: 200,
              // height: 500,
              fit: BoxFit.fill,
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemCount: data.length >= 7 ? 7 : data.length,
            itemBuilder: (context, index) =>
                CustomCardItem(data: data.elementAt(index)),
          );
  }
}

class CustomCardItem extends ConsumerWidget {
  const CustomCardItem({
    super.key,
    required this.data,
    this.value = '',
    this.height = 270,
    this.width = 230,
    this.focusNode,
  });
  final double? width, height;
  final Ressources data;
  final String value;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AudioPlayerService audioPlayer = AudioPlayerServiceImpl();
    final theme = FluentTheme.of(context);
    final isGame = data.type!.any((element) => element.id == '6');
    final haslocalLink = data.localLink!.isEmpty;

    final canChangeColor = isGame && haslocalLink;

    final color = canChangeColor ? Colors.red.withOpacity(0.1) : Colors.white;

    return GestureDetector(
      onTap: () async {
        // await audioPlayer.playClickSound();
        final _ = ref.refresh(isConnectedProvider);
        const transitionDuration = Duration(milliseconds: 100);

        // if (Platform.isIOS)
        SystemSound.play(
            Platform.isMacOS ? SystemSoundType.alert : SystemSoundType.click);
        // ignore: use_build_context_synchronously
        debugPrint(data.toJson().toString());
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: transitionDuration,
            reverseTransitionDuration: transitionDuration,
            pageBuilder: (_, animation, ___) {
              return FadeTransition(
                opacity: animation,
                child: DetailsActivity(data: data),
              );
            },
          ),
        );
      },
      child: HoveredCard(
        width: width!,
        height: height!,
        child: Stack(
          children: [
            Container(
              width: width!,
              // margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? Colors.grey : color,
              ),
              child: GestureDetector(
                onDoubleTap: () async {
                  final copyText = '${data.title}';
                  await FlutterClipboard.copy(copyText);
                  if (context.mounted) showCopiedSnackbar(context, copyText);
                },
                // hoverColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      data.image!.isEmpty
                          ? imgPlaceHolder
                          : data.image!
                              .replaceAll(RegExp(r'é'), 'e')
                              .replaceAll(RegExp(r'è'), 'e'),
                      fit: BoxFit.fill,
                      width: width!,
                      height: 170,
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Text(
                          data.title!,
                          // textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 5.0,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: '',
                                style: FluentTheme.of(context)
                                    .typography
                                    .subtitle
                                    ?.copyWith(fontSize: 14),
                                children: <TextSpan>[
                                  if (data.type!.isNotEmpty)
                                    ...data.type!.map(
                                      (e) => TextSpan(
                                          text: e.title,
                                          style: FluentTheme.of(context)
                                              .typography
                                              .subtitle
                                              ?.copyWith(
                                                  color: theme.brightness == Brightness.dark
                                                      ? kPrimaryColor
                                                      : kSecondaryColor,
                                                  fontSize: 11),
                                          children: [
                                            if (e.id !=
                                                data.type
                                                    ?.elementAt(
                                                        data.type!.length - 1)
                                                    .id)
                                              TextSpan(
                                                  text: ', ',
                                                  style: FluentTheme.of(context)
                                                      .typography
                                                      .subtitle
                                                      ?.copyWith(
                                                          color: theme
                                                                  .brightness
                                                                  == Brightness.dark
                                                              ? kPrimaryColor
                                                              : kSecondaryColor,
                                                          fontSize: 11)),
                                          ]),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // m.Positioned(
            //   right: 5,
            //   top: 5,
            //   child: IconButton(
            //     icon: Icon(
            //       FluentIcons.add_favorite,
            //       color: Colors.red,
            //       size: 20,
            //     ),
            //     onPressed: () {},
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    super.key,
    required this.imageUrl,
    required this.username,
  });

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
          ),
          shape: BoxShape.circle,
        ),
      ),
      Text(username),
    ]);
  }
}
