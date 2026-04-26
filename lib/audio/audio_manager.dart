import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isTvLiveProvider = StateProvider((ref) => true, name: 'counter');

// // import 'package:just_audio/just_audio.dart';
final isPlayingProvider = StateProvider<bool>((ref) => false);

final audioProvider = ChangeNotifierProvider<AudioManager>(
    (ref) => AudioManager(ref.read(isPlayingProvider)));

class AudioManager with ChangeNotifier {
  bool _isPlaying = false;
  bool get isPlayings => _isPlaying;
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  PlayerState? _playerState;
  PlayerState? get playerState => _playerState;

  AudioManager(bool isPlayingProvider) {
    if (isPlayingProvider) {
      print("isPlayingProvider");
    } else {
      print("_init");
      _init();
    }
  }

  // setState(() {
  //                                               ref
  //                                                       .read(
  //                                                           isPlayingProvider
  //                                                               .notifier)
  //                                                       .state =
  //                                                   ref
  //                                                       .read(audioProvider
  //                                                           .notifier)
  //                                                       .isPlayings;
  //                                             });

  void setPlayings(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    setAudio();

    /// listen to states : playsing, paused, stop
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      isPlaying = state == PlayerState.playing;
      if (state == PlayerState.playing) {
        buttonNotifier.value = ButtonState.playing;
      } else if (state == PlayerState.paused) {
        buttonNotifier.value = ButtonState.paused;
      } else {
        resumer();
        buttonNotifier.value = ButtonState.playing; //loading;
      }
      notify();
    });
  }

  notify() {
    notifyListeners();
  }

  Future setAudio({String url = "loader"}) async {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // _audioPlayer.setSourceUrl(url);
    await _audioPlayer.setSource(AssetSource('sfx/$url.mp3'));
    await _audioPlayer.resume();
  }

  void play() async {
    if (isPlaying) {
      pause();
    } else {
      resumer();
    }
  }

  void resumer() {
    _audioPlayer.resume();
  }

  void stop() {
    _audioPlayer.stop();
  }

  void pause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
