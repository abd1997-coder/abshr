import 'package:flutter/material.dart';

/// Root [ScaffoldMessenger] for app-wide SnackBars (e.g. Dio errors without [BuildContext]).
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
