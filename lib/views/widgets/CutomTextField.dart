
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{

  TextEditingController? cont;
  String? hntTxt;
  Icon? prfxIcon;
  IconButton? sffxIcon;
  String? obscChar;
  bool? obscText;

  CustomTextField({required hintText, prefixIcon, suffixIcon, controller, obscureText, obscureChar}){
    hntTxt = hintText;
    prfxIcon = prefixIcon;
    sffxIcon = suffixIcon;
    cont = controller;
    obscText = obscureText;
    obscChar = obscureChar;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: TextFormField(
        controller: cont,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          hintStyle: TextStyle(color: Colors.black38),
          hintText : hntTxt,
          prefixIcon: prfxIcon,
          suffixIcon: sffxIcon,
        ),
        obscuringCharacter: obscChar ?? '*',
        obscureText: obscText ?? false,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 5),
                blurRadius: 5
            ),
            BoxShadow(
              color: Colors.white,
            ),
          ]
      ),
    );
  }
}