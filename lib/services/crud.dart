import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:non_vaccinated_region/model/Count.dart';
import 'package:non_vaccinated_region/model/Profile.dart';
import 'package:non_vaccinated_region/model/District.dart';

import 'package:non_vaccinated_region/services/api.dart';

class Crud{

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference ref_state = _firestore.collection("india");

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

  //Return list of states
  Future<List<String>> statesList() async{
    final QuerySnapshot states = await ref_state.get();
    List<QueryDocumentSnapshot> list = states.docs;

    List<String> state = [];
    try{
      await Api.getData();
    }catch(e){
      print('Api Exception: ${e}');
    }

    //States
    for(QueryDocumentSnapshot l in list) {
      state.add(l.id);
    }

    return state;
  }

  //Return List of districts of a specific state
  static Future<List<District>> districtsList(String stateName) async{
    CollectionReference ref_district = ref_state.doc(stateName).collection("districts");
    QuerySnapshot districts = await ref_district.get();

    List<QueryDocumentSnapshot> dist_list = districts.docs;

    List<District> district = [];

    //States
    for(QueryDocumentSnapshot l in dist_list) {
      DocumentSnapshot snap = await ref_district.doc(l.id).get();

      district.add(
        new District(
          name: l.id,
          dose1: snap['dose1'],
          dose2: snap['dose2']
        )
      );
    }

    return district;
  }

  //Return List of taluks of a specific district
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

  //Return List of towns with dose1 & dose2 count of a specific taluk
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

  //Return List of villages with dose1 & dose2 count of a specific taluk
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
    bool success_state = false;
    bool success_district = false;
    bool success_taluk = false;
    bool success_town = false;
    bool success_village = false;

    //State
    CollectionReference state_ref  = FirebaseFirestore.instance.collection("india");
    success_state = await state_ref.doc(state).set({}).then((value) => true);

    //District
    CollectionReference district_ref  = state_ref.doc(state).collection("districts");
    success_district = await district_ref.doc(district).set({
      "dose1": 0,
      "dose2": 0
    }).then((value) => true);

    //Taluk
    CollectionReference ref = district_ref.doc(district).collection("taluks");
    success_taluk = await ref.doc(taluk).set({}).then((value) => true);

    if(isTown){
      //Set Town
      success_town = await ref.doc(taluk).collection("towns").doc(town).set({
        "dose1": 0,
        "dose2": 0
      }).then((value) => true);

      return success_state && success_district && success_taluk && success_town;
    }else{
      //Set Village
      success_village = await ref.doc(taluk).collection("village").doc(village).set({
        "dose1": 0,
        "dose2": 0
      }).then((value) => true);

      return success_state && success_district && success_taluk && success_village;
    }

  }

  //Get Profile
  static Future<Profile> getProfile(String uid) async{
    DocumentSnapshot snapshot = await _firestore.collection("admins").doc(uid).get();

    return new Profile(
      name: snapshot['name'],
      email: snapshot['email'],
      hospital: snapshot['hospital']
    );

  }

  //Add User details
  static Future<String> addAdmin(String uid, String username, String hospital, String email) async{

    return await  _firestore.collection("admins").doc(uid).set({
      'name': username,
      'hospital': hospital,
      'email': email
    })
        .then((value) => "")
        .catchError((onError) => onError);

  }

  //Update count
  static Future<bool> updateCount(String stateName, String districtName, String talukName, String townName, String villageName, bool isDose1) async{
    DocumentReference ref_district = ref_state.doc(stateName).collection("districts").doc(districtName);
    CollectionReference ref_taluk = ref_district.collection("taluks");
    DocumentReference documentReference;

    if(townName.isNotEmpty){
      documentReference = ref_taluk.doc(talukName).collection("towns").doc(townName);
    }
    if(villageName.isNotEmpty){
      documentReference = ref_taluk.doc(talukName).collection("village").doc(villageName);
    }

    //Updating count using transaction
    bool response = await _firestore.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Something went wrong");
      }

      // Perform an update on the document
      if(isDose1){
        transaction.update(documentReference, {'dose1': FieldValue.increment(1)});
      }else{
        transaction.update(documentReference, {'dose2': FieldValue.increment(1)});
      }

    }).then((value) { //Success
      print("Count updated");
      return true;
    }).catchError((error) { //Error
      print("Failed to update count: $error");
      return false;
    });


    //Updating count of distict using transaction
    return await _firestore.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(ref_district);

      if (!snapshot.exists) {
        throw Exception("Something went wrong");
      }

      // Perform an update on the document
      if(isDose1){
        transaction.update(ref_district, {'dose1': FieldValue.increment(1)});
      }else{
        transaction.update(ref_district, {'dose2': FieldValue.increment(1)});
      }

    }).then((value) { //Success
      print("Count updated in district");
      return true;
    }).catchError((error) { //Error
      print("Failed to update count: $error");
      return false;
    }) && response;
  }
}