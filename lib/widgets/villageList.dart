import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/model/Count.dart';

import 'package:non_vaccinated_region/details/data.dart';

class VillageList extends StatefulWidget {
  String stateName, districtName, talukName;
  Function callback;  //Callback of reload function

  VillageList({this.stateName, this.districtName, this.talukName, this.callback});

  @override
  _VillageListState createState() => _VillageListState();
}

class _VillageListState extends State<VillageList> {

  //Storing the state of panels
  List<bool> activeList = [];

  //Return villageList from db
  Future<List<Count>> getList() async{
    List<Count> list = await Crud.villageList(widget.stateName, widget.districtName, widget.talukName);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getList(),
        builder: (context, snapshot){
          if(snapshot.hasData){

            if(Data.isUserLoggedIn){  //For admin
              List<CheckboxListTile> list = [];
              for(Count name in snapshot.data){
                list.add(
                    CheckboxListTile(
                      value: (Data.selectedName == name.name)? true: false,
                      onChanged: (val){
                        if(val){
                          setState(() {
                            Data.selectedName = name.name;
                            widget.callback(widget.stateName, widget.districtName, widget.talukName, "", name.name, true);
                          });
                        }else{
                          setState(() {
                            Data.selectedName = "";
                            widget.callback(widget.stateName, widget.districtName, widget.talukName, "", "", false);
                          });
                        }
                      },
                      title: Text(
                          name.name,
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey
                      ),
                      ),
                    )
                );
              }
              return Column(
                children: list,
              );

            }else{  //For regular users
              List<ExpansionPanel> list = [];

              int index=0;
              for(Count name in snapshot.data){
                activeList.add(false);
                list.add(
                    ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return Center(
                            child: Text(
                              name.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                fontStyle: (isExpanded)? FontStyle.italic: null,
                                fontSize: 16.0,
                                color: Colors.blueGrey
                              ),
                            ),
                          );
                        },
                        body: Container(
                          //Display Count of Dose1 and Dose2
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dose 1:  ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        '${name.dose1}',
                                        style: TextStyle(
                                            fontSize: 16.0
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dose 2:  ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        '${name.dose2}',
                                        style: TextStyle(
                                            fontSize: 16.0
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        isExpanded: activeList[index],
                        canTapOnHeader: true
                    )
                );
                index++;
              }

              return ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    activeList[panelIndex] = !activeList[panelIndex];
                  });
                },
                children: list,
              );

            }

          }

          //Loading
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
