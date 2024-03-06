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
                    Padding(
                      padding: const EdgeInsets.only(left: 11.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/nalsoft_logo.png',
                            scale: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      'Explore Our Services',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    buildService(
                      image_path: 'assets/images/meals.png',
                      size: size,
                      context: context,
                      color: Color.fromRGBO(234, 221, 255, 1),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteManagement.dataLoader);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    buildService(
                      image_path: 'assets/images/meetings.png',
                      size: size,
                      context: context,
                      color: Color.fromARGB(255, 187, 196, 199),
                      onTap: () {
                        Navigator.pushNamed(context, RouteManagement.homeView);
                      },
                    )
                  ]),
            ))));
  }

  Widget buildService(
      {required String image_path,
      required Size size,
      required BuildContext context,
      required Color color,
      required void Function()? onTap}) {
    return InkWell(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: size.height * 0.18,
          width: size.width * 0.9,
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 10),
              borderRadius: BorderRadius.circular(25)),
          child: Image.asset(image_path, fit: BoxFit.fill),
        ),
        onTap: onTap);
  }
}
