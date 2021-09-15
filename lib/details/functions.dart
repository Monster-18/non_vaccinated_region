import 'package:flutter/material.dart';

BoxDecoration background(){
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[100],
            Colors.white
          ]
      )
  );
}