import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/details/data.dart';
import 'package:non_vaccinated_region/details/functions.dart';

class ProfilePage extends StatelessWidget {

  //For displaying data
  Padding display(String title, String data){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ':',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              data,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        decoration: background(),
        child: FutureBuilder(
          future: Crud.getProfile(Data.user_id),
          builder:(context, snapshot){
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  display('Name', snapshot.data.name),
                  display('Email', snapshot.data.email),
                  display('Hospital', snapshot.data.hospital)
                ],
              );
            }

            //Loading...
            return Center(child: CircularProgressIndicator());
          }
        ),
      ),
    );
  }
}
