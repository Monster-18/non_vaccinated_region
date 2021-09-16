import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:non_vaccinated_region/model/chart/TalukDetail.dart';

import 'package:non_vaccinated_region/services/crud.dart';

import 'package:non_vaccinated_region/model/chart/DistrictDetail.dart';

import 'package:non_vaccinated_region/model/chart/DataSeries.dart';

class ChartPage extends StatefulWidget {
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<charts.Series<DataSeries, String>> series = null;
  List<charts.Series<DataSeries, String>> taluk_series = null;

  TextEditingController districtController = new TextEditingController();

  bool isDose1 = true, isTalukDose1 = true;
  bool txt_error = false;
  DistrictDetail details = null;

  List<Color> colors = [Colors.blue, Colors.teal, Colors.green, Colors.yellow];
  int color_index = 0;

  void createSeriesForDistrict(){
    series = null;
    series = [
      charts.Series(
          id: (isDose1)? "Dose 1": "Dose2",
          data: [
            DataSeries(
                title: (isDose1)? 'DOSE 1': 'Dose2',
                count: (isDose1)? details.dose1: details.dose2,
                color: charts.ColorUtil.fromDartColor(Colors.green)
            ),
            DataSeries(
                title: 'POPULATION',
                count: details.population - ((isDose1)? details.dose1: details.dose2),
                color: charts.ColorUtil.fromDartColor(Colors.blue)
            ),
          ],
          domainFn: (DataSeries series, _) => series.title,
          measureFn: (DataSeries series, _) => series.count,
          colorFn: (DataSeries series, _) => series.color
      )
    ];
  }

  //Return list of taluk
  List<DataSeries> talukData(){
    List<DataSeries> list = [];
    int maxData = 0;

    for(TalukDetail t in details.taluks){
      list.add(
          DataSeries(
              title: t.name,
              count: (isTalukDose1)? t.dose1: t.dose2,
              color: charts.ColorUtil.fromDartColor(colors[color_index])
          )
      );

      if(isTalukDose1){
        if(t.dose1 > maxData){
          maxData = t.dose1;
        }
      }else{
        if(t.dose2 > maxData){
          maxData = t.dose2;
        }
      }

      color_index = (color_index+1)%4;
    }

    if(maxData == 0){
      list.add(
          DataSeries(
              title: 'Not Vaccinated',
              count: details.population,
              color: charts.ColorUtil.fromDartColor(Colors.blue)
          )
      );
    }
    return list;
  }

  void createSeriesForTaluks(){
    taluk_series = null;
    taluk_series = [
      charts.Series(
          id: (isTalukDose1)? "Taluk Dose 1": "Taluk Dose2",
          data: talukData(),
          domainFn: (DataSeries series, _) => series.title,
          measureFn: (DataSeries series, _) => series.count,
          colorFn: (DataSeries series, _) => series.color
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'CHART',
          style: TextStyle(
            fontStyle: FontStyle.italic
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 320,
                      child: TextField(
                        controller: districtController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a District...',
                          errorText: (txt_error)? 'Unable to find the district': null
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async{
                        if(districtController.text.isNotEmpty){
                          DistrictDetail response = await Crud.searchDistrict(districtController.text);
                          if(response == null){
                            setState(() {
                              txt_error = true;
                            });
                          }else{
                            txt_error = false;
                            details = response;
                            createSeriesForDistrict();
                            createSeriesForTaluks();
                            setState(() { });
                          }
                        }
                      },
                      icon: Icon(Icons.search),
                    )
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width-10,
                height: 350,
                child: (details == null)? Center(child: Text('Choose a district'),):
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Based on District',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
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
                                  groupValue: isDose1,
                                  onChanged: (value){
                                    isDose1 = value;
                                    createSeriesForDistrict();
                                    setState(() { });
                                  },
                                ),
                                Text('Dose 1')
                              ],
                            ),
                            //Village
                            Row(
                              children: [
                                Radio(
                                  value: false,
                                  groupValue: isDose1,
                                  onChanged: (value){
                                    isDose1 = value;
                                    createSeriesForDistrict();
                                    setState(() { });
                                  },
                                ),
                                Text('Dose2')
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: charts.PieChart(
                            series,
                            defaultRenderer: charts.ArcRendererConfig(
                                arcRendererDecorators: [
                                  charts.ArcLabelDecorator(
                                      labelPosition: charts.ArcLabelPosition.auto
                                  )
                                ],
                            ),
                            animate: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width-10,
                height: 350,
                child: (taluk_series == null)? Center(child: Text('Choose a district'),):
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Based on Taluks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
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
                                  groupValue: isTalukDose1,
                                  onChanged: (value){
                                    isTalukDose1 = value;
                                    createSeriesForTaluks();
                                    setState(() { });
                                  },
                                ),
                                Text('Dose 1')
                              ],
                            ),
                            //Village
                            Row(
                              children: [
                                Radio(
                                  value: false,
                                  groupValue: isTalukDose1,
                                  onChanged: (value){
                                    isTalukDose1 = value;
                                    createSeriesForTaluks();
                                    setState(() { });
                                  },
                                ),
                                Text('Dose2')
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: charts.PieChart(
                            taluk_series,
                            defaultRenderer: charts.ArcRendererConfig(
                                arcRendererDecorators: [
                                  charts.ArcLabelDecorator(
                                      labelPosition: charts.ArcLabelPosition.auto,
                                  ),
                                ],
                              arcWidth: 70
                            ),
                            animate: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
