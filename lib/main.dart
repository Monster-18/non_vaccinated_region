import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:non_vaccinated_region/home.dart';
import 'package:non_vaccinated_region/screens/login.dart';
import 'package:non_vaccinated_region/screens/dose_1.dart';

import 'package:non_vaccinated_region/screens/add_places.dart';

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
        '/dose1': (context) => Dose1(),

        //Adding new places
        '/addPlace': (context) => AddPlace(),
      },
    )
  );
}