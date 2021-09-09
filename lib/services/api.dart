import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:non_vaccinated_region/details/data.dart';

class Api{
  static final String url = "https://data.covid19india.org/v4/min/data.min.json";

  static Future<bool> getData() async{
    var response = await http.get(url);

    Data.json = json.decode(response.body);

    // print(resJson['TN']['districts']['Coimbatore']['total']['vaccinated1']);
    // print(resJson['TN']['districts']['Coimbatore']['total']['vaccinated2']);
  }
}