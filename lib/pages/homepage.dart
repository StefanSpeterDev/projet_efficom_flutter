import 'package:flutter/material.dart';
import 'package:projet_efficom/pages/caloriepage.dart';
import 'package:projet_efficom/pages/drawer.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: CaloriePage(title: 'Bienvenue $name',)
    );
  }
}