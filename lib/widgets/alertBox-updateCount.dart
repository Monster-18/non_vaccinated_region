import 'package:flutter/material.dart';

class AlertBox extends StatefulWidget {
  Function changeDose;

  AlertBox({this.changeDose});

  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  bool isDose1 = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Dose'),
      content: Container(
        child: Container(
          child: Row(
            children: [
              Radio(
                  value: true,
                  groupValue: isDose1,
                  onChanged: (val){
                    setState(() {
                      isDose1 = val;
                    });
                    widget.changeDose(val);
                  }
              ),
              Text('Dose 1'),

              Radio(
                  value: false,
                  groupValue: isDose1,
                  onChanged: (val){
                    setState(() {
                      isDose1 = val;
                    });
                    widget.changeDose(val);
                  }
              ),
              Text('Dose 2')
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Ok')
        )
      ],
    );
  }
}
