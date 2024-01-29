import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomLegend extends StatelessWidget {
  const CustomLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legend(
            color: Colors.green.shade200,
            text: 'Opted',
          ),
          _legend(
            color: Colors.orange.shade200,
            text: 'Not Opted',
          ),
          _legend(
            color: Colors.red.shade100,
            text: 'Holiday',
          ),
          _legend(
            color: Colors.grey.shade300,
            text: 'No Status',
          ),
        ],
      ),
    );
  }

  Widget _legend({required color, required text}) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
