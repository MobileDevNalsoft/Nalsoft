
import 'package:flutter/material.dart';

class Widgets{
  Widget InfoList({required content}){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content.entries.map((MapEntry<String, String> entry) {
            return Text(
              entry.key,
              style: TextStyle(color: Colors.black54, fontSize: 16),
            );
          }).toList(),
        ),
        Column(
          children: content.entries.map((MapEntry<String, String> entry) {
            return Text(
              ":",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            );
          }).toList(),
        ),
        Column(
          children: content.entries.map((MapEntry<String, String> entry) {
            return Text(
              entry.value,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            );
          }).toList(),
        )
      ],
    );
  
  }
  Widget textFormField({cont,required hntTxt, prfxIcon, obscChar, obscText, sffxIcon}){
    return TextFormField(
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
    );
  }

  Widget fieldElevation({required child}){
    return Container(
      child: child,
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