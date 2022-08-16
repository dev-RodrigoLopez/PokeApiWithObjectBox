import 'package:flutter/material.dart';

import 'package:object_box_pokeapi/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'HomePage',
      navigatorKey: navigatorKey, // Navegar
      routes: getApplicationRoutes(),
    );
  }
}