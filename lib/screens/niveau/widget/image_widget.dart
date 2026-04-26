// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/audio/audio_manager.dart';
import 'package:example/audio/data/audio_player_service_impl.dart';
import 'package:example/audio/services/audio_player_service.dart';
import 'package:example/provider/providers.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import '../../main_home.dart';
import 'app_style.dart';

class ImageWidget extends ConsumerStatefulWidget {
  String url;
  Function()? onTap;
  final int index;
  ImageWidget({
    super.key,
    this.url = '',
    this.onTap,
    this.index = 0,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;
  @override
  ConsumerState<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends ConsumerState<ImageWidget> {
  final height = 340.0;
  bool isHovered = false;

  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();

  @override
  void initState() {
    super.initState();
  }

  void playButtonSound() {
    // audioCache.loadPath(('click1.mp3'));
    // audioPlayer.play(AssetSource(clickUrl));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        CashHelper.setBool(key: 'showNiveau', value: true);
        CashHelper.saveData(key: 'indexNiveau', value: widget.index);

        // playButtonSound();
        await _audioPlayerService.playClickSound();

        // widget.audioPlayer!.setAudio(url: "click1");
        ref.read(downloadProvider.notifier).setMenu(widget.index.toString());
        ref
            .read(downloadProvider.notifier)
            .setMenuStat(widget.index.toString());
        ref
            .read(niveauNotifierProvider.notifier)
            .fetchRessource(niveau: convertLevel(widget.index.toString()));
        const transitionDuration = Duration(milliseconds: 100);
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
        // if (widget.audioPlayer != null) widget.audioPlayer!.stop();
        // if (widget.audioPlayer != null) widget.audioPlayer!.dispose();
      },
      onHover: (value) {
        isHovered = value;
        setState(() {});
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.url,
              // scale: 1,
              height: SizeConfig.blockSizeH! * 65.5,
              width: SizeConfig.blockSizeH! * 80,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedContainer(
            duration: kThemeAnimationDuration,
            height: SizeConfig.blockSizeH! * 65.5,
            width: SizeConfig.blockSizeH! * 80,
            alignment: Alignment.center,
            // margin: const EdgeInsets.only(right: 48, bottom: 48),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: isHovered
                  ? Colors.black.withOpacity(0.4)
                  : Colors.transparent,
            ),
            child: isHovered
                ? const Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.white,
                    size: 32,
                  )
                : const Offstage(),
          ),
        ],
      ),
    );
  }
}

class ActivityWidget extends ConsumerStatefulWidget {
  String url;
  Function()? onTap;
  final int index;

  ActivityWidget(
      {super.key,
      this.url = '',
      this.onTap,
      this.index = 0,
      required this.pageController});
  final PageController pageController;
  @override
  ConsumerState<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends ConsumerState<ActivityWidget> {
  final height = 340.0;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return
        // InkWell(
        //   onTap: () {
        //     ref.read(downloadProvider.notifier).setMenu(widget.index.toString());
        //     ref
        //         .read(niveauNotifierProvider.notifier)
        //         .fetchRessource(niveau: convertLevel(widget.index.toString()));
        //   },
        //   onHover: (value) {
        //     isHovered = value;
        //     setState(() {});
        //   },
        // child:

        GestureDetector(
      onTap: () {
        SystemSound.play(
            Platform.isMacOS ? SystemSoundType.alert : SystemSoundType.click);
        ref.read(downloadProvider.notifier).setIndex(widget.index.toString());
        ref
            .read(activitiesNotifierProvider.notifier)
            .fetchRessource(niveau: convertLevel(widget.index.toString()));
        ref.read(niveauNotifierProvider.notifier).fetchRessource(
            niveau: convertLevel(ref.watch(downloadProvider).niveau!));
        print(convertLevel(ref.watch(downloadProvider).niveau!));
        widget.pageController.jumpToPage(1);
      },
      child: f.Stack(
        children: [
          f.ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: f.Image.asset(
              widget.url,
              // scale: 1,
              height: SizeConfig.blockSizeH! * 65.5,
              width: SizeConfig.blockSizeH! * 80,
              fit: BoxFit.cover,
            ),
          ),
          f.AnimatedContainer(
            duration: kThemeAnimationDuration,
            height: SizeConfig.blockSizeH! * 65.5,
            width: SizeConfig.blockSizeH! * 80,
            alignment: Alignment.center,
            // margin: const EdgeInsets.only(right: 48, bottom: 48),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: isHovered
                  ? f.Colors.black.withOpacity(0.4)
                  : f.Colors.transparent,
            ),
            child: isHovered
                ? const f.Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.white,
                    size: 32,
                  )
                : const f.Offstage(),
          ),
        ],
        // ),
      ),
    );
  }
}
