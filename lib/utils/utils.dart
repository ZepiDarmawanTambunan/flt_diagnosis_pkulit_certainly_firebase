import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastMessage(
      {String message = 'default message', Color color = Colors.red}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  List<DropdownMenuItem<double>> dropdownList(){
    return [
      const DropdownMenuItem(
        value: 0.0,
        child: Text('0.0'),
      ),
      const DropdownMenuItem(
        value: 0.1,
        child: Text('0.1'),
      ),
      const DropdownMenuItem(
        value: 0.2,
        child: Text('0.2'),
      ),
      const DropdownMenuItem(
        value: 0.3,
        child: Text('0.3'),
      ),
      const DropdownMenuItem(
        value: 0.4,
        child: Text('0.4'),
      ),
      const DropdownMenuItem(
        value: 0.5,
        child: Text('0.5'),
      ),
      const DropdownMenuItem(
        value: 0.6,
        child: Text('0.6'),
      ),
      const DropdownMenuItem(
        value: 0.7,
        child: Text('0.7'),
      ),
      const DropdownMenuItem(
        value: 0.8,
        child: Text('0.8'),
      ),
      const DropdownMenuItem(
        value: 0.9,
        child: Text('0.9'),
      ),
      const DropdownMenuItem(
        value: 1.0,
        child: Text('1.0'),
      ),
    ];
  }
}
