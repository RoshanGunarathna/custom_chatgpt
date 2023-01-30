import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../singleton/audio_player.dart';

class Play {
  static AudioPlayer player = Player.player;

  static void base64Player(String audio) async {
    await player.stop();
    Uint8List decodedbytes = base64.decode(audio.substring(23));
    await player.setAudioSource(MyCustomSource(decodedbytes));
    player.play();
  }

  static void assetPlayer(String audioPath) async {
    await player.stop();
    await player.setAsset(audioPath);
    player.play();
  }
}

// bytes into the player
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
