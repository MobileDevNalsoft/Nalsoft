import 'package:flutter/material.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/data_loader_page.dart';
import 'package:meals_management/views/screens/meeting_rooms_management/home_view.dart';

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
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DataLoader(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1, 0.0);
                              const end = Offset.zero;
                              final tween = Tween(begin: begin, end: end);
                              final offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
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
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomeView(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1, 0.0);
                              const end = Offset.zero;
                              final tween = Tween(begin: begin, end: end);
                              final offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
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
