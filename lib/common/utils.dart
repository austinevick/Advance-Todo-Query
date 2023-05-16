import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void showSnackBar(String msg,
        {bool showLabel = true, VoidCallback? onPressed}) =>
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text(msg),
        action: SnackBarAction(
            label: showLabel ? 'UNDO' : '', onPressed: onPressed ?? () {})));

void push(Widget child) => Navigator.push(
    navigatorKey.currentContext!,
    PageTransition(
        duration: const Duration(milliseconds: 700),
        type: PageTransitionType.rightToLeft,
        child: child));
