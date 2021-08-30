import 'package:flutter/material.dart';
//DB
import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/widgets/districtList.dart';

class StateList extends StatefulWidget {

  @override
  _StateListState createState() => _StateListState();
}

class _StateListState extends State<StateList> {

  List<bool> activeList = [];

  Future<List<String>> getList() async{
    Crud crud = new Crud();
    List<String> list = await crud.statesList();
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
                          child: DistrictList(stateName: name),
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

          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
