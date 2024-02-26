import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  Function()? onPressed;
  Widget? child;
  MaterialStateProperty<Color?>? color;

  CustomElevatedButton(
      {super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
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
