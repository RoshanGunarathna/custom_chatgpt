import 'dart:convert';

import 'package:custom_chatgpt/common/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required VoidCallback onSuccess,
  required BuildContext context,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    default:
      var res = jsonDecode(response.body);
      showSnackBar(
        context,
        res,
      );
      print("error: ${res.toString()}");
  }
}
