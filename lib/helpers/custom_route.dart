import 'package:flutter/material.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == ProductOverviewScreen.RouteName) {
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }
}

class CustomPageTransitionBuider extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == ProductOverviewScreen.RouteName) {
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }
}
