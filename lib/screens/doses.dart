import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:non_vaccinated_region/widgets/stateList.dart';
import 'package:non_vaccinated_region/details/data.dart';
import 'package:non_vaccinated_region/widgets/alertBox-updateCount.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/details/functions.dart';

class Doses extends StatefulWidget {
  @override
  _DosesState createState() => _DosesState();
}

class _DosesState extends State<Doses> {
  //For Updating vaccine count
  String stateName, districtName, talukName, townName, villageName;

  //For clicking only once
  bool clickedOnce = false;

  //For displaying Floating Action Button
  bool isSelected = false;

  //For updating count
  bool isDose1 = true;

  //Loading
  bool isLoading = false;

  //For reloading this state when admin selected a village or town
  void reload(String stateName, String districtName, String talukName, String townName, String villageName, bool flag){
    setState(() {
      isSelected = flag;
    });

    this.stateName = stateName;
    this.districtName = districtName;
    this.talukName = talukName;
    this.townName = townName;
    this.villageName = villageName;

  }

  //Set back to default
  void setBackToDefault(){
    Data.selectedName = "";
    isDose1 = true;

    isSelected = false;
    stateName = null;
    districtName = null;
    talukName = null;
    townName = null;
    villageName = null;

    clickedOnce = false;
  }

  //Change dose
  void changeDose(bool flag){
    isDose1 = flag;
  }

  //Alert box for updating dose1 or dose2
  Future<void> alertBox(){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertBox(
            changeDose: changeDose,
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'DOSE',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 21
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[100],
                    Colors.red[50]
                  ]
              )
          ),
          constraints: BoxConstraints(
            minHeight:MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
          ),

          //List of States
          child: (isLoading)?
              Center(child: CircularProgressIndicator()):
              StateList(
                callback: reload,
              ),

        ),
      ),

      //Updating Count
      floatingActionButton: (isSelected && !isLoading)? FloatingActionButton.extended(
        onPressed: () async{
          if(clickedOnce){
            print('Already pressed');
          }else{
            clickedOnce = true;
            if(townName.isEmpty && villageName.isEmpty){
              print('Oops: Both town and village is empty');
            }else{
              await alertBox();

              setState(() {
                isLoading = true;
              });

              bool response = await Crud.updateCount(stateName, districtName, talukName, townName, villageName, isDose1);

              setState(() {
                isLoading = false;
              });

              if(response){
                Toast.show("Update Success", context, duration: 2, gravity:  Toast.BOTTOM);
              }else{
                Toast.show('Update failure', context, duration: 2, gravity:  Toast.BOTTOM);
              }

              //Set back to default
              setBackToDefault();

              setState(() { }); //Reload
            }
          }
        },
          label: Text(
              'Update Count',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        backgroundColor: Colors.blue,
        ): null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
