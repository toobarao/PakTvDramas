import 'dart:convert';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/splash_screen.dart';
import '../utilities/app_theme.dart';
class MainAppWrapper extends StatefulWidget {
  final Widget child;
  const MainAppWrapper({required this.child, super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> with WidgetsBindingObserver {
  bool _initialLaunch = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialLaunch = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_initialLaunch && state == AppLifecycleState.resumed) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (navigatorKey.currentState?.mounted ?? false) {
          navigatorKey.currentState!.push(
            PageRouteBuilder(
              opaque: true,
              pageBuilder: (_, __, ___) => SplashPage(),
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            if (navigatorKey.currentState!.canPop()) {
              navigatorKey.currentState!.pop();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

