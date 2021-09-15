import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/widgets/talukList.dart';
import 'package:non_vaccinated_region/model/District.dart';

import 'package:non_vaccinated_region/details/data.dart';

class DistrictList extends StatefulWidget {
  String stateName;
  Function callback;  //Callback of reload function

  DistrictList({this.stateName, this.callback});

  @override
  _DistrictListState createState() => _DistrictListState();
}

class _DistrictListState extends State<DistrictList> {

  //Storing the state of panels
  List<bool> activeList = [];

  //Return districtList from db
  Future<List<District>> getList() async{
    List<District> list = await Crud.districtsList(widget.stateName);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getList(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<ExpansionPanel> list = [];

            int index=0;
            for(District district in snapshot.data){
              activeList.add(false);
              list.add(
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Center(
                          child: Text(
                            district.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                              fontStyle: (isExpanded)? FontStyle.italic: null,
                              color: Colors.teal,
                              fontSize: 18.0
                            ),
                          ),
                        );
                      },
                      body: SingleChildScrollView(
                        child: Container(
                          //List of taluks
                          child: Column(
                            children: [
                              (district.name == "Bangalore")? Container():
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'DOSE 1: ',
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        '${Data.json[Data.state[widget.stateName]]['districts'][district.name]['total']['vaccinated1'] - district.dose1}',
                                        style: TextStyle(
                                          color: Colors.green
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          'DOSE 2: ',
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                          '${Data.json[Data.state[widget.stateName]]['districts'][district.name]['total']['vaccinated2'] - district.dose2}',
                                        style: TextStyle(
                                            color: Colors.green
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              TalukList(
                                  stateName: widget.stateName,
                                  districtName: district.name,
                                  callback: widget.callback,
                              ),
                            ],
                          ),
                        ),
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

          //Loading
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
