import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: senderMsgColor,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 10, right: 30, bottom: 20),
                child: Text(
                  message.trim(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 10,
                    color: msgDateColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
