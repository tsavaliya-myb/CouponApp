// lib/core/navigation/app_route_observer.dart
import 'package:flutter/material.dart';

/// Global observer used by keep-alive screens to detect when a route is
/// pushed on top of them (e.g. Home -> Seller Detail) or revealed again.
final RouteObserver<ModalRoute<dynamic>> appRouteObserver =
    RouteObserver<ModalRoute<dynamic>>();
