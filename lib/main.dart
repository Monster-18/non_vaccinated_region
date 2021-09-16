import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:non_vaccinated_region/home.dart';
import 'package:non_vaccinated_region/screens/login.dart';
import 'package:non_vaccinated_region/screens/signup.dart';
import 'package:non_vaccinated_region/screens/profile.dart';
import 'package:non_vaccinated_region/screens/doses.dart';

import 'package:non_vaccinated_region/screens/add_places.dart';
import 'package:non_vaccinated_region/screens/chart.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      title: 'Non Vaccinated Region',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/doses': (context) => Doses(),
        '/profile': (context) => ProfilePage(),

        //Adding new places
        '/addPlace': (context) => AddPlace(),

        '/chart': (context) => ChartPage(),
      },
    )
  );
}