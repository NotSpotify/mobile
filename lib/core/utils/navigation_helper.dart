import 'package:flutter/material.dart';

void navigateToAndReplaceAll(BuildContext context, String routeName) {
  Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
}
