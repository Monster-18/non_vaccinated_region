import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:non_vaccinated_region/services/crud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //Password Visibility
  bool visible = false;

  TextEditingController idController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
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
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: (){
                    // AuthService auth = new AuthService();
                    //
                    // auth.registerWithEmailAndPassword("abc@gmail.com", "123456");

                    Crud c = new Crud();
                    c.getStates();
                  },
                  child: Text(
                      'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: (){
                        print('Sign Up');
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
    );
  }
}
