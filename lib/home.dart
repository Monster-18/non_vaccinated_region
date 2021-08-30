import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/login');
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
                  text: 'Dose 1',
                  callback: (){
                    print("Dose 1");
                    Navigator.pushNamed(context, '/dose1');
                  }
              ),
              CustomButton(
                text: 'Dose 2',
                callback: () async{
                  print("Dose 2");
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
