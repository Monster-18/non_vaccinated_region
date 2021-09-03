import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/widgets/talukList.dart';

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
  Future<List<String>> getList() async{
    List<String> list = await Crud.districtsList(widget.stateName);
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
            for(String name in snapshot.data){
              activeList.add(false);
              list.add(
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Center(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontWeight: (isExpanded)? FontWeight.bold: FontWeight.normal
                            ),
                          ),
                        );
                      },
                      body: SingleChildScrollView(
                        child: Container(
                          //List of taluks
                          child: TalukList(
                              stateName: widget.stateName,
                              districtName: name,
                              callback: widget.callback,
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
