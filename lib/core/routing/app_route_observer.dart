import 'package:flutter/widgets.dart';

/// App-wide [RouteObserver] registered on the root navigator. Screens that need
/// to refresh when a route above them is popped (e.g. the bills list after
/// returning from create/detail) mix in [RouteAware] and subscribe to this.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();
