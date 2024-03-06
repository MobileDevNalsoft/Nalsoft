import 'package:flutter/material.dart';
import 'package:meals_management/route_management/route_management.dart';

class AppNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: AspectRatio(
            aspectRatio: size.height / size.width,
            child: Scaffold(
                body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.22,
                        ),
                        Image.asset(
                          'assets/images/nalsoft_logo.png',
                          scale: 4,
                        ),
                      ],
                    ),
                    Text(
                      'Explore Our Services',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: size.height * 0.2,
                        width: size.width*0.9,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(234, 221, 255, 1),
                                width: 10),
                            borderRadius: BorderRadius.circular(25)),
                        child: Image.asset(
                          'assets/images/meals.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteManagement.dataLoader);
                      },
                    )
                  ]),
            ))));
  }
}
