import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/details/functions.dart';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  //Loading...
  bool isLoading = false;

  //Controllers
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController talukController = new TextEditingController();
  TextEditingController townController = new TextEditingController();
  TextEditingController villageController = new TextEditingController();

  bool stateError = false;
  bool districtError = false;
  bool talukError = false;
  bool townError = false;
  bool villageError = false;
  bool isTown = true;

  String errot_text = "Should not be empty";

  //For Checking TextFields
  bool checkFieldsEmpty(){
    if(stateController.text.trim().isEmpty){
      stateError = true;
    }else{
      stateError = false;
    }

    if(districtController.text.trim().isEmpty){
      districtError = true;
    }else{
      districtError = false;
    }

    if(talukController.text.trim().isEmpty){
      talukError = true;
    }else{
      talukError = false;
    }

    if(isTown){
      if(townController.text.trim().isEmpty){
        townError = true;
      }else{
        townError = false;
      }
    }else{
      if(villageController.text.trim().isEmpty){
        villageError = true;
      }else{
        villageError = false;
      }
    }

    setState(() { });

    return !stateError && !districtError && !talukError && !townError && !villageError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'ADD PLACE',
          style: TextStyle(
            fontSize: 20.0
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
        ),
        decoration: background(),
        child: (isLoading)?
            Center(child: CircularProgressIndicator()):
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: stateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'State',
                        errorText: (stateError)? errot_text: null
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: districtController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'District',
                          errorText: (districtError)? errot_text: null
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: talukController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Taluk',
                          errorText: (talukError)? errot_text: null
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Town
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: isTown,
                            onChanged: (value){
                              setState(() {
                                isTown = value;
                                villageController.clear();
                              });
                            },
                          ),
                          Text('Town')
                        ],
                      ),
                      //Village
                      Row(
                        children: [
                          Radio(
                            value: false,
                            groupValue: isTown,
                            onChanged: (value){
                              setState(() {
                                isTown = value;
                                townController.clear();
                              });
                            },
                          ),
                          Text('Village')
                        ],
                      )
                    ],
                  ),

                  (isTown)?
                    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: townController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Town',
                          errorText: (townError)? errot_text: null
                      ),
                    ),
                  ):
                    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: villageController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Village',
                          errorText: (villageError)? errot_text: null
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue)
                        ),
                        onPressed: () async{
                          if(checkFieldsEmpty()){
                            setState(() {
                              isLoading = true;
                            });

                            bool flag = await Crud.addNewPlaces(stateController.text.trim(), districtController.text.trim(), talukController.text.trim(), townController.text.trim(), villageController.text.trim(), isTown);

                            setState(() {
                              isLoading = false;
                            });

                            if(flag){
                              Toast.show("Added Successfully", context, duration: 2, gravity:  Toast.BOTTOM);
                              setState(() {
                                townController.clear();
                                villageController.clear();
                              });
                            }else{
                              Toast.show("Something went wrong", context, duration: 2, gravity:  Toast.BOTTOM);
                            }
                          }
                        },
                        child: Text(
                            'Add Place',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }
}
