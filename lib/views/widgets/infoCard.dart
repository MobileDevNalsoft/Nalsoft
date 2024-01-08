import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Map<String, String> content;
  const InfoCard({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
}
