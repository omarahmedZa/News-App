import 'package:flutter/cupertino.dart';

Text myTextStyle({
  required String text,
}) => Text(
  text,
  style: const TextStyle(
    color: CupertinoColors.black,
  ),
);