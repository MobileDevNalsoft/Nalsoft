
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget{

  double? width;
  String? value;
  Widget hint;
  void Function(String?)? onChanged;
  List<DropdownMenuItem<String>>? items;
  double? menuMaxHeight;

  CustomDropDown({super.key, this.width, required this.value, required this.hint, required this.items, this.onChanged,required this.menuMaxHeight});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: width,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
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
      child: DropdownButton<String>(
        hint: hint,
        value: value,
        onChanged: onChanged,
        items: items,
        alignment: Alignment.center,
        menuMaxHeight: menuMaxHeight,
        borderRadius: BorderRadius.circular(15),
        underline: Container(),
      ),
    );
  }
}