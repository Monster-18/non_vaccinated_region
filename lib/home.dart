import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:non_vaccinated_region/services/auth.dart';
import 'package:non_vaccinated_region/details/data.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          (Data.isUserLoggedIn) ?
                //Logout Button if user logged in
                IconButton(
                  onPressed: () async{
                    print('Logout');
                    AuthService auth = new AuthService();
                    await auth.signOut();
                    Toast.show("Successfully Logged out", context, duration: 2, gravity:  Toast.BOTTOM);
                    setState(() {
                      Data.isUserLoggedIn = false;
                      Data.user_id = null;
                    });
                  },
                  icon: Icon(Icons.logout),
                ):

                //Login button if user not logged in
                IconButton(
                  onPressed: () async{
                    await Navigator.pushNamed(context, '/login');
                    setState(() {

                    });
                  },
                  icon: Icon(Icons.login),
                )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  text: 'Dose',
                  callback: (){
                    print("Dose");
                    Navigator.pushNamed(context, '/doses');
                  }
              ),
              CustomButton(
                  text: 'Add New Place',
                  callback: (){
                    Navigator.pushNamed(context, '/addPlace');
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  CustomButton({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width*3/4,
        onPressed: callback,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
