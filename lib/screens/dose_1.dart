import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:non_vaccinated_region/widgets/stateList.dart';

class Dose1 extends StatefulWidget {
  @override
  _Dose1State createState() => _Dose1State();
}

class _Dose1State extends State<Dose1> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dose 1'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: StateList(),
        ),
      ),
    );
  }
}
