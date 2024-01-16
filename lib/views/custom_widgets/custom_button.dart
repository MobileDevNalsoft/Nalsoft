
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget{

  Function()? onPressed;
  Widget? child;
  MaterialStateProperty<Color?>? color;

  CustomButton({super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: color,
        elevation: const MaterialStatePropertyAll(5),
      ),
      child: child,
    );
  }
}