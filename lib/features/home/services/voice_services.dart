import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/error_handling.dart';
import '../../../common/player.dart';
import '../../../common/show_snackbar.dart';

class VoiceServices {
  //text to voice
  void requestVoice({
    required BuildContext context,
    required String voiceType,
    required String text,
  }) async {
    const String _url = 'http://api.voicerss.org';
    const String _key = 'e5036442dee542489ac853895e2bf55e';

    try {
      http.Response res = await http.post(Uri.parse(
          "$_url/?key=$_key&hl=en-us&c=MP3&f=16khz_8bit_stereo&b64=true&v=Mary&src=$text"));

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          //send response to player
          Play.base64Player(res.body);
        },
      );
    } catch (e) {
      print('Error in catch : ${e.toString()} **');
      showSnackBar(context, e.toString());
    }
  }
}
