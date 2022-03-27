import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 3),
  ));
}

String parseTime(String time) {
  final dateTime = DateTime.parse(time);

  final format = DateFormat('dd MM yyyy hh:mm:ss aa');
  String clockString = format.format(dateTime);
  return clockString;
}

