import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/widgets/villageList.dart';
import 'package:non_vaccinated_region/widgets/townList.dart';

class TalukList extends StatefulWidget {
  String stateName, districtName;
  Function callback;  //Callback of reload function

  TalukList({this.stateName, this.districtName, this.callback});

  @override
  _TalukListState createState() => _TalukListState();
}

class _TalukListState extends State<TalukList> {

  //Storing the state of panels
  List<bool> activeList = [];

  List<bool> activeSub = [];

  //Return talukList from db
  Future<List<String>> getList() async{
    activeSub.add(false);
    activeSub.add(false);
    List<String> list = await Crud.talukList(widget.stateName, widget.districtName);
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
                          child: ExpansionPanelList(
                            expansionCallback: (panelIndex, isExpanded) {
                              setState(() {
                                activeSub[panelIndex] = !activeSub[panelIndex];
                              });
                            },
                            children: [
                              ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return Center(
                                      child: Text(
                                        'Town',
                                        style: TextStyle(
                                            fontWeight: (isExpanded)? FontWeight.bold: FontWeight.normal
                                        ),
                                      ),
                                    );
                                  },
                                  body: SingleChildScrollView(
                                    child: Container(
                                      //List of towns
                                      child: TownList(
                                          stateName: widget.stateName,
                                          districtName: widget.districtName,
                                          talukName: name,
                                          callback: widget.callback,
                                      ),
                                    ),
                                  ),
                                  isExpanded: activeSub[0],
                                  canTapOnHeader: true
                              ),
                              ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return Center(
                                      child: Text(
                                        'Villages',
                                        style: TextStyle(
                                            fontWeight: (isExpanded)? FontWeight.bold: FontWeight.normal
                                        ),
                                      ),
                                    );
                                  },
                                  body: SingleChildScrollView(
                                    child: Container(
                                      //List of villages
                                      child: VillageList(
                                          stateName: widget.stateName,
                                          districtName: widget.districtName,
                                          talukName: name,
                                          callback: widget.callback,
                                      ),
                                    ),
                                  ),
                                  isExpanded: activeSub[1],
                                  canTapOnHeader: true
                              )
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
