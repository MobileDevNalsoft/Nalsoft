import 'package:flutter/material.dart';

class CustomSnackBar{
  static Widget? showSnackBar(BuildContext context,String content,Color color){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(content),backgroundColor: color,)
    );
    return null;
  }
}