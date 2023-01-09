import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/error_handling.dart';
import '../../../common/show_snackbar.dart';

class AiServices {
  //send customer msg to backend and get ai response
  Future<String?> sendMsgToAi({
    required BuildContext context,
    required String msg,
  }) async {
    late String? botMsg;
    const String _url = "https://api.openai.com/v1/completions";
    const String _apiKey =
        "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";
    try {
      http.Response res = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": '$msg',
          "temperature": 0,
          "max_tokens": 100,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": ["Human:", "AI:"]
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var data = jsonDecode(res.body.toString());
          var resMsg = data['choices'][0]['text'];
          botMsg = resMsg;
        },
      );
    } catch (e) {
      print('Error in catch : ${e.toString()} **');
      showSnackBar(context, e.toString());
    }
    return botMsg;
  }
}
