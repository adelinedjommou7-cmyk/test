import 'package:audioplayers/audioplayers.dart';
import 'package:example/audio/services/audio_player_service.dart';
import 'package:example/widgets/helper.dart';

class AudioPlayerServiceImpl implements AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> playClickSound() async {
    try {
      await _audioPlayer.play(
          AssetSource(clickUrl)); // Le son doit être placé dans assets/audio/
    } catch (e) {
      print('Erreur lors de la lecture du son: $e');
    }
  }

  @override
  Future<void> playClick1Sound() async {
    try {
      await _audioPlayer.play(
          AssetSource(clickUrl)); // Le son doit être placé dans assets/audio/
    } catch (e) {
      print('Erreur lors de la lecture du son: $e');
    }
  }
}
