// ignore_for_file: deprecated_member_use

import 'dart:async';
// import "package:audioplayers/audio_cache.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:example/audio/audio_manager.dart';
import 'package:example/provider/providers.dart';
import 'package:example/screens/main_home.dart';
import 'package:example/screens/niveau/niveau_page.dart';
import 'package:example/theme.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import '../../widgets/router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
// class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController? _controller;
  late AudioPlayer audioPlayer;
  late AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: (12)),
      vsync: this,
    );
    // audioCache = AudioCache(prefix: 'assets/sounds/');
    // Create the audio player.
    audioPlayer = AudioPlayer();
    // Set the release mode to keep the source after playback has completed.
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    audioPlayer.setSource(AssetSource('sfx/loader.mp3'));
    audioPlayer.resume();
    _init();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void _init() async {
    // audioPlayer =
    //     await audioCache.load(fileName);
    //..loop('background_music.mp3');
    // Add this line to override the default close handler
    setState(() {});
  }

  Future<void> _deletecachedir() async {
    final tempdir = await getTemporaryDirectory();
    if (tempdir.existsSync()) {
      tempdir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteappdir() async {
    final appdocdir = await getApplicationDocumentsDirectory();

    if (appdocdir.existsSync()) {
      appdocdir.deleteSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isThemeSet = CashHelper.getData(key: 'theme') ?? 1;
    // final appTheme = ref.watch(themeProvider);
    // final mode = ThemeMode.values[isThemeSet];
    // appTheme.mode = mode;
    // appTheme.setEffect(appTheme.windowEffect, context);
    // print(isThemeSet);
    // if (widget.shellContext != null) {
    //   if (router.canPop() == false) {
    //     setState(() {});
    //   }
    // }
    return material.Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 50, right: 10),
              child: Image.asset(
                'assets/icons/icon.png',
                width: 500.0,
                height: 250.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Lottie.asset(
              "assets/json/progress2.json",
              controller: _controller,
              height: MediaQuery.of(context).size.height * 0.15,
              animate: true,
              onLoaded: (composition) {
                _controller!
                  ..duration = composition.duration
                  ..forward().whenComplete(() async {
                    //CLEAR CACHE
                    if (kDebugMode) {
                      print('//CLEAR CACHE');
                      //await Future.wait([_deletecachedir(), _deleteappdir()]);
                      //RESTART APP
                      print('//RESTART APP');
                    }
                    const transitionDuration = Duration(milliseconds: 100);
                    Future.microtask(() =>
                        Future.delayed(const Duration(seconds: 2), () async {
                          final isShowTuto =
                              CashHelper.getBool(key: 'showNiveau') ?? false;
                          audioPlayer.stop();
                          audioPlayer.dispose();
                          if (isShowTuto == false) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: transitionDuration,
                                reverseTransitionDuration: transitionDuration,
                                pageBuilder: (_, animation, ___) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: NiveauPage(
                                      shellContext: widget.shellContext,
                                      child: widget.child,
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            final intex =
                                CashHelper.getData(key: 'indexNiveau') ?? 0;
                            ref
                                .read(downloadProvider.notifier)
                                .setMenu(intex.toString());
                            ref
                                .read(downloadProvider.notifier)
                                .setMenuStat(intex.toString());
                            ref
                                .read(niveauNotifierProvider.notifier)
                                .fetchRessource(
                                    niveau: convertLevel(intex.toString()));
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: transitionDuration,
                                reverseTransitionDuration: transitionDuration,
                                pageBuilder: (_, animation, ___) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: MyHomePage(
                                      shellContext: widget.shellContext,
                                      child: widget.child,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }));
                  });
              },
            ),
          ],
        ),
      ),
    );
  }
}
