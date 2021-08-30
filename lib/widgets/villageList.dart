import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/model/Count.dart';

class VillageList extends StatefulWidget {
  String stateName, districtName, talukName;

  VillageList({this.stateName, this.districtName, this.talukName});

  @override
  _VillageListState createState() => _VillageListState();
}

class _VillageListState extends State<VillageList> {

  List<bool> activeList = [];

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
            List<ExpansionPanel> list = [];

            int index=0;
            for(Count name in snapshot.data){
              activeList.add(false);
              list.add(
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Center(
                          child: Text(
                            name.getName(),
                            style: TextStyle(
                                fontWeight: (isExpanded)? FontWeight.bold: FontWeight.normal
                            ),
                          ),
                        );
                      },
                      body: Container(
                        height: 40,
                          child: Column(
                            children: [
                              Text('Dose 1: ${name.getDose1()}'),
                              Text('Dose 2: ${name.getDose2()}'),
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

          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
