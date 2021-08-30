import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:non_vaccinated_region/model/Count.dart';


class Crud{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference ref_state;

  Future<List<String>> getStates() async{
    CollectionReference ref_state = _firestore.collection("india");
    final QuerySnapshot states = await ref_state.get();
    List<QueryDocumentSnapshot> list = states.docs;

    //States
    for(QueryDocumentSnapshot l in list){
      print("State: " + l.id);

      CollectionReference ref_district = ref_state.doc(l.id).collection("districts");
      QuerySnapshot districts = await ref_district.get();
      List<QueryDocumentSnapshot> dist_list = districts.docs;

      //Districts
      for(QueryDocumentSnapshot d in dist_list){
        print("District: " + d.id);

        CollectionReference ref_taluk = ref_district.doc(d.id).collection("taluks");
        QuerySnapshot taluks = await ref_taluk.get();
        List<QueryDocumentSnapshot> taluks_list = taluks.docs;

        //Taluks
        for(QueryDocumentSnapshot t in taluks_list){
          print("Taluks: " + t.id);

          CollectionReference ref_towns = ref_taluk.doc(t.id).collection("towns");
          QuerySnapshot towns = await ref_towns.get();
          List<QueryDocumentSnapshot> town_list = towns.docs;

          //Towns
          for(QueryDocumentSnapshot to in town_list){
            print("Town: " + to.id);

            DocumentSnapshot town = await ref_towns.doc(to.id).get();
            print(town['vaccine_count']);
          }

          CollectionReference ref_village = ref_taluk.doc(t.id).collection("village");
          QuerySnapshot village = await ref_village.get();
          List<QueryDocumentSnapshot> vil_list = village.docs;

          //Villages
          for(QueryDocumentSnapshot v in vil_list){
            print("Village: " + v.id);

            DocumentSnapshot vil = await ref_village.doc(v.id).get();
            print(vil['vaccine_count']);
          }

        }
      }
    }

    return [];
  }

  Future<List<String>> statesList() async{
    ref_state = _firestore.collection("india");
    final QuerySnapshot states = await ref_state.get();
    List<QueryDocumentSnapshot> list = states.docs;

    List<String> state = [];

    //States
    for(QueryDocumentSnapshot l in list) {
      state.add(l.id);
    }

    return state;
  }

  static Future<List<String>> districtsList(String stateName) async{
    CollectionReference ref_district = ref_state.doc(stateName).collection("districts");
    QuerySnapshot districts = await ref_district.get();

    List<QueryDocumentSnapshot> dist_list = districts.docs;

    List<String> district = [];

    //States
    for(QueryDocumentSnapshot l in dist_list) {
      district.add(l.id);
    }

    return district;
  }

  static Future<List<String>> talukList(String stateName, String districtName) async{
    CollectionReference ref_taluk = ref_state.doc(stateName).collection("districts").doc(districtName).collection("taluks");
    QuerySnapshot taluks = await ref_taluk.get();

    List<QueryDocumentSnapshot> taluks_list = taluks.docs;

    List<String> taluk = [];

    //States
    for(QueryDocumentSnapshot l in taluks_list) {
      taluk.add(l.id);
    }

    return taluk;
  }

  static Future<List<Count>> townList(String stateName, String districtName, String talukName) async{
    CollectionReference ref_towns = ref_state.doc(stateName).collection("districts").doc(districtName).collection("taluks").doc(talukName).collection("towns");
    QuerySnapshot towns = await ref_towns.get();

    List<QueryDocumentSnapshot> town_list = towns.docs;

    List<Count> town = [];

    //States
    for(QueryDocumentSnapshot l in town_list) {
      DocumentSnapshot c = await ref_towns.doc(l.id).get();
      Count count = new Count(
          name: l.id,
          dose1: c['dose1'],
          dose2: c['dose2']
      );
      town.add(count);
    }

    return town;
  }

  static Future<List<Count>> villageList(String stateName, String districtName, String talukName) async{
    CollectionReference ref_village = ref_state.doc(stateName).collection("districts").doc(districtName).collection("taluks").doc(talukName).collection("village");
    QuerySnapshot villages = await ref_village.get();

    List<QueryDocumentSnapshot> village_list = villages.docs;

    List<Count> village = [];

    //States
    for(QueryDocumentSnapshot l in village_list) {
      DocumentSnapshot c = await ref_village.doc(l.id).get();
      Count count = new Count(
          name: l.id,
          dose1: c['dose1'],
          dose2: c['dose2']
      );
      village.add(count);
    }

    return village;
  }

  //Add new Places
  static Future<bool> addNewPlaces(String state, String district, String taluk, String town, String village, bool isTown) async{
    bool success = false;
    bool success1 = false;
    bool success2 = false;

    CollectionReference ref_start  = FirebaseFirestore.instance.collection("india").doc(state)
        .collection("districts");

    //Set District Count
    success = await ref_start.doc(district).set({
      "dose1": 0,
      "dose2": 0
    }).then((value) => true);

    CollectionReference ref = ref_start.doc(district).collection("taluks");

    if(isTown){
      //Set Town
      success1 = await ref.doc(taluk).collection("towns").doc(town).set({
        "dose1": 0,
        "dose2": 0
      }).then((value) => true);

      return success && success1;
    }else{
      //Set Village
      success2 = await ref.doc(taluk).collection("village").doc(village).set({
        "dose1": 0,
        "dose2": 0
      }).then((value) => true);

      return success && success2;
    }

  }

}