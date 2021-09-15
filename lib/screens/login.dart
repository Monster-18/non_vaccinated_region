import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:non_vaccinated_region/services/auth.dart';

import 'package:non_vaccinated_region/details/functions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Loading...
  bool isLoading = false;

  //Password Visibility
  bool visible = false;

  //Text Editing Controllers
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //Empty error
  bool isEmpty_email = false;
  bool isEmpty_password = false;

  //Checking whether user enters any data
  bool check(){
    if(emailController.text.trim().isEmpty){
      isEmpty_email = true;
    }else{
      isEmpty_email = false;
    }

    if(passwordController.text.trim().isEmpty){
      isEmpty_password = true;
    }else{
      isEmpty_password = false;
    }

    return !isEmpty_email && !isEmpty_password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'LOGIN',
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
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Username
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (val){
                          setState(() {
                            isEmpty_email = false;
                          });
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          errorText: (isEmpty_email)? 'Should not be empty': null
                        ),
                      ),
                    ),

                    //Password
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (val){
                          setState(() {
                            isEmpty_password = false;
                          });
                        },
                        obscureText: (visible)? false: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          errorText: (isEmpty_password)? 'Should not be empty': null,
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
                        ),
                      ),
                    ),

                    //Login Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () async{
                          AuthService auth = new AuthService();
                          //
                          // auth.registerWithEmailAndPassword("abc@gmail.com", "123456");

                          // Crud c = new Crud();
                          // c.getStates();

                          if(check()){
                            setState(() {
                              isLoading = true;
                            });

                            String response = await auth.loginWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());

                            setState(() {
                              isLoading = false;
                            });

                            if(response.isEmpty){
                              Toast.show("Success", context, duration: 2, gravity:  Toast.BOTTOM);
                              Navigator.pop(context);
                            }else{
                              Toast.show(response, context, duration: 2, gravity:  Toast.BOTTOM);
                            }
                          }else{
                            print('Oops');
                          }
                          setState(() { });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Text(
                            'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    //Space
                    SizedBox(height: 10),

                    //For creating new account
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account? '),
                          GestureDetector(
                            onTap: (){
                              //Navigate to SignUp page
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                                'Sign up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2.0
                              ),
                            ),
                          )
                        ],
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
