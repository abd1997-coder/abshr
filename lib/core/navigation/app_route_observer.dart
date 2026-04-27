import 'package:flutter/material.dart';

/// Used so screens (e.g. [HomePage]) can refresh when a pushed route is popped.
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
