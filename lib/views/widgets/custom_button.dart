
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{

  Function()? onPressed;
  Widget? child;
  MaterialStateProperty<Color?>? color;

  CustomButton({super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(BuildContext){
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: color,
        elevation: MaterialStatePropertyAll(5),
      ),
      child: child,
    );
  }
}