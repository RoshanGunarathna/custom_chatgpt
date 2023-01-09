import 'package:just_audio/just_audio.dart';

class Player {
  Player._private();
  static final Player _player = Player._private();
  static AudioPlayer? _audioPlayer;

  static AudioPlayer get player {
    if (_audioPlayer != null) return _audioPlayer!;
    _audioPlayer = AudioPlayer();
    return _audioPlayer!;
  }
}
