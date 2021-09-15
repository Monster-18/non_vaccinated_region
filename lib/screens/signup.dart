import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:non_vaccinated_region/services/auth.dart';

import 'package:non_vaccinated_region/details/functions.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Loading...
  bool isLoading = false;

  //Password Visibility
  bool visible = false;

  //Validating
  bool err_email = false;
  bool err_password = false;
  bool err_confirmPassword = false;

  //Empty
  bool isEmpty_username = false;
  bool isEmpty_hospital = false;
  bool isEmpty_email = false;
  bool isEmpty_password = false;
  bool isEmpty_confirmPassword = false;

  //Text Editing Controllers
  TextEditingController usernameController = new TextEditingController();
  TextEditingController hospitalController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  //Execute when the signup button is pressed
  bool check(){
    if(usernameController.text.trim().isEmpty){
      isEmpty_username = true;
    }else{
      isEmpty_username = false;
    }

    if(hospitalController.text.trim().isEmpty){
      isEmpty_hospital = true;
    }else{
      isEmpty_hospital = false;
    }

    if(emailController.text.trim().isEmpty){
      isEmpty_email = true;
    }else{
      isEmpty_confirmPassword = false;
    }

    if(passwordController.text.trim().isEmpty){
      isEmpty_password = true;
    }else{
      isEmpty_password = false;
    }

    if(confirmPasswordController.text.trim().isEmpty){
      isEmpty_confirmPassword = true;
    }else{
      isEmpty_confirmPassword = false;
    }

    if(passwordController.text.trim() != confirmPasswordController.text.trim()){
      err_confirmPassword = true;
    }

    return !isEmpty_username && !isEmpty_hospital && !isEmpty_confirmPassword && !isEmpty_password && !isEmpty_confirmPassword
          && !err_email && !err_password && !err_confirmPassword && passwordController.text.trim() == confirmPasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'SIGN UP',
          style: TextStyle(
              fontSize: 20
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: background(),
        child: Center(
          child: (isLoading)?
              CircularProgressIndicator():
              SingleChildScrollView(
                child: Column(
                  children: [
                    //Username
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (val){
                          setState(() {
                            isEmpty_username = false;
                          });
                        },
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          errorText: (isEmpty_username)? 'Should not be empty': null,
                        ),
                      ),
                    ),

                    //Hospital
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (val){
                          setState(() {
                            isEmpty_hospital = false;
                          });
                        },
                        controller: hospitalController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Hospital',
                          errorText: (isEmpty_hospital)? 'Should not be empty': null,
                        ),
                      ),
                    ),

                    //Email
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (String val){
                          setState(() {
                            isEmpty_email = false;
                            err_email = !RegExp(r"^([a-z\_\.\-0-9]+)@([a-z\-0-9]+)\.([a-z]{2,4}(\.?[a-z]+))").hasMatch(val);
                          });
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          errorText: (isEmpty_email)? 'Should not be empty': (err_email)? 'Invalid Email': null,
                        ),
                      ),
                    ),

                    //Password
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (String val){
                          isEmpty_password = false;
                          if(val.trim().length < 6){
                            setState(() {
                              err_password = true;
                            });
                          }else{
                            setState(() {
                              err_password = false;
                            });
                          }
                        },
                        obscureText: (visible)? false: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                visible = !visible;
                              });
                            },
                            child: Icon(
                                (visible)? Icons.visibility: Icons.visibility_off
                            ),
                          ),
                          errorText: (isEmpty_password)? 'Should not be empty': (err_password)? "Should contain atleast 6 characters": null,
                        ),
                      ),
                    ),

                    //Confirm Password
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (String val){
                          isEmpty_confirmPassword = false;
                          if(val != passwordController.text){
                            setState(() {
                              err_confirmPassword = true;
                            });
                          }else{
                            setState(() {
                              err_confirmPassword = false;
                            });
                          }
                        },
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          errorText: (isEmpty_confirmPassword)? 'Should not be empty': (err_confirmPassword)? 'Should match password': null,
                        ),
                      ),
                    ),

                    //Space
                    SizedBox(
                      height: 20.0,
                    ),

                    //Signup Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () async{
                          if(check()){
                            AuthService auth = new AuthService();

                            setState(() {
                              isLoading = true;
                            });

                            String response = await auth.registerWithEmailAndPassword(usernameController.text.trim(), hospitalController.text.trim(), emailController.text.trim(), passwordController.text.trim());

                            setState(() {
                              isLoading = false;
                            });

                            if(response.isEmpty){
                              Toast.show("Registration success", context, duration: 2, gravity:  Toast.BOTTOM);
                              Navigator.pop(context);
                            }else{
                              Toast.show(response, context, duration: 2, gravity:  Toast.BOTTOM);
                            }
                          }else{
                            Toast.show("Invalid data", context, duration: 2, gravity:  Toast.BOTTOM);
                          }
                          setState(() { });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
