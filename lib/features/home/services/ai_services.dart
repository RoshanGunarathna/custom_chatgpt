import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/error_handling.dart';
import '../../../common/show_snackbar.dart';
import '../../../constants/constant.dart';

class AiServices {
  //send customer msg to backend and get ai response
  Future<String?> sendMsgToAi({
    required BuildContext context,
    required String msg,
  }) async {
    late String? botMsg;

    try {
      http.Response res = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "message": msg,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var resMsg = jsonDecode(res.body)['message'];
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
