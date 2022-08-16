import 'package:flutter/material.dart';
import 'package:object_box_pokeapi/app/homepage/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'HomePage': (BuildContext context) => const HomePage(),
  };
}