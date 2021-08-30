import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //SigIn with email & password

  //Register with email & password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(res.user);
    }catch(e){
      print(e);
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