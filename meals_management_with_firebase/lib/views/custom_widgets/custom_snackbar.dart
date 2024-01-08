import 'package:flutter/material.dart';

class CustomSnackBar{
  static Widget? showSnackBar(BuildContext context,String content){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(content))
    );
    return null;
  }
}