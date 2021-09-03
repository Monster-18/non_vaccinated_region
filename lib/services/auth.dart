import 'package:firebase_auth/firebase_auth.dart';

import 'package:non_vaccinated_region/details/data.dart';

import 'package:non_vaccinated_region/services/crud.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //SigIn with email & password
  Future<String> loginWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(res.user);
      Data.user_id = res.user.uid;
      Data.isUserLoggedIn = true;
      return "";
    }catch(e){
      print('Exception: ${e.toString().split("[").last.split("/").last.split("]").first.toString()}');
      return e.toString().split("[").last.split("/").last.split("]").first.toString();
    }
  }


  //Register with email & password
  Future<String> registerWithEmailAndPassword(String username, String hospital, String email, String password) async{
    try{
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(res.user.uid);
      return await Crud.addAdmin(res.user.uid, username, hospital, email);
    }catch(e){
      print('Exception: ${e}');
      return e.toString().split("[").last.split("/").last.split("]").first.toString();
    }
  }

  //Signout
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}