import 'package:non_vaccinated_region/model/chart/TalukDetail.dart';

class DistrictDetail{
  String name;
  int population, dose1, dose2;
  List<TalukDetail> taluks;

  DistrictDetail({this.name, this.population, this.dose1, this.dose2, this.taluks});
}