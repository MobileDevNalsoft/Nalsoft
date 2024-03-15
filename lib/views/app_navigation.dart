import 'package:flutter/material.dart';
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/views/in_app_tour.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/data_loader_page.dart';
import 'package:meals_management/views/screens/meeting_rooms_management/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final mealsAppkey = GlobalKey();

  final meetingsAppkey = GlobalKey();

  final sharedPreferences = sl.get<SharedPreferences>();

  late TutorialCoachMark tutorialCoachMark;

  void _initAddSiteInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addAppNavigationSiteTargets(
        mealsAppkey: mealsAppkey,
        meetingsAppkey: meetingsAppkey,
      ),
      colorShadow: Colors.black12,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      onFinish: () {
        print('app navigation tutorial completed');
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        tutorialCoachMark.show(context: context);
        sharedPreferences.setBool('hasSeenTutorial1', true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (!sharedPreferences.containsKey('hasSeenTutorial1')) {
      _initAddSiteInAppTour();
      _showInAppTour();
    }
  }

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
                    const Text(
                      'Explore Our Services',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    buildService(
                      key: mealsAppkey,
                      image_path: 'assets/images/meals.png',
                      size: size,
                      context: context,
                      color: const Color.fromRGBO(234, 221, 255, 1),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const DataLoader(),
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
                    // buildService(
                    //   key: meetingsAppkey,
                    //   image_path: 'assets/images/meetings.png',
                    //   size: size,
                    //   context: context,
                    //   color: const Color.fromARGB(255, 187, 196, 199),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       PageRouteBuilder(
                    //         transitionDuration:
                    //             const Duration(milliseconds: 400),
                    //         pageBuilder:
                    //             (context, animation, secondaryAnimation) =>
                    //                 HomeView(),
                    //         transitionsBuilder: (context, animation,
                    //             secondaryAnimation, child) {
                    //           const begin = Offset(1, 0.0);
                    //           const end = Offset.zero;
                    //           final tween = Tween(begin: begin, end: end);
                    //           final offsetAnimation = animation.drive(tween);
                    //           return SlideTransition(
                    //             position: offsetAnimation,
                    //             child: child,
                    //           );
                    //         },
                    //       ),
                    //     );
                    //   },
                    // )
                  ]),
            ))));
  }

  Widget buildService(
      {required GlobalKey key,
      // ignore: non_constant_identifier_names
      required String image_path,
      required Size size,
      required BuildContext context,
      required Color color,
      required void Function()? onTap}) {
    return InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          key: key,
          height: size.height * 0.18,
          width: size.width * 0.9,
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 10),
              borderRadius: BorderRadius.circular(25)),
          child: Image.asset(image_path, fit: BoxFit.fill),
        ));
  }
}
