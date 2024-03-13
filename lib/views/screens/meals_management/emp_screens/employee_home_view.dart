import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/meals_management/user_data_provider.dart';
import 'package:meals_management/repositories/user_repo.dart';
import 'package:meals_management/views/app_navigation.dart';
import 'package:meals_management/views/custom_widgets/custom_calendar_card.dart';
import 'package:meals_management/views/custom_widgets/custom_legend.dart';
import 'package:meals_management/views/in_app_tour.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:meals_management/views/screens/meals_management/admin_screens/admin_home_view.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/employee_preview_view.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/employee_update_upcoming_status_view.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:custom_widgets/src.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// ignore: must_be_immutable
class EmployeeHomeView extends StatefulWidget {
  late Function? initData;
  EmployeeHomeView({super.key, this.initData});

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView>
    with ConnectivityMixin {
  DateTime now = DateTime.now();

  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  UserRepo userRepo = UserRepo();

  final sharedPreferences = sl.get<SharedPreferences>();

  late Stream<DocumentSnapshot> _stream;

  final calendarKey = GlobalKey();
  final legendKey = GlobalKey();
  final updateUpcomingLunchStatusKey = GlobalKey();
  final notificationsKey = GlobalKey();
  final toggleKey = GlobalKey();
  final logoutKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void _initAddSiteInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addEmployeeHomeSiteTargets(
          calendarKey: calendarKey,
          legendKey: legendKey,
          updateUpcomingLunchStatusKey: updateUpcomingLunchStatusKey,
          notificationsKey: notificationsKey,
          toggleKey: toggleKey,
          logoutKey: logoutKey),
      colorShadow: Colors.black12,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      onFinish: () {
        print('employee home tutorial completed');
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        tutorialCoachMark.show(context: context);
        sharedPreferences.setBool('hasSeenTutorial2', true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('notifications')
        .doc(DateTime.now().toString().substring(0, 10))
        .snapshots();
    if (!sharedPreferences.containsKey('hasSeenTutorial2')) {
      _initAddSiteInAppTour();
      _showInAppTour();
    }
  }

  @override
  void dispose() {
    datesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: size.height * 0.13,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 179, 110, 234),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                          width: size.width * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Hi,\n${sharedPreferences.getString('employee_name')}',
                              style: TextStyle(
                                  fontSize: size.width * 0.057,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Consumer<UserDataProvider>(
                          builder: (context, provider, child) {
                            return Stack(
                              children: [
                                IconButton(
                                  key: notificationsKey,
                                  icon: const Icon(Icons.notifications),
                                  onPressed: () {
                                    // Handle notification button press
                                    provider.setUnseen = false;

                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 200),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            NotificationsView(stream: _stream),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1, 0.0);
                                          const end = Offset.zero;
                                          final tween =
                                              Tween(begin: begin, end: end);
                                          final offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                sharedPreferences.getBool('unseen')!
                                    ? const Positioned(
                                        right: 13,
                                        top: 14,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          maxRadius: 4.5,
                                        ))
                                    : const SizedBox(),
                              ],
                            );
                          },
                        ),
                        sharedPreferences.getString('user_type') == 'A'
                            ? Switch(
                                key: toggleKey,
                                value: false,
                                onChanged: (value) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const AdminHomePage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                activeColor:
                                    const Color.fromARGB(255, 181, 129, 248),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, left: 10),
                          child: PopupMenuButton(
                            key: logoutKey,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                    value: 'Log Out',
                                    height: 10,
                                    padding: const EdgeInsets.only(left: 25),
                                    onTap: () {
                                      init();
                                      sharedPreferences.remove('employee_name');
                                      sharedPreferences.remove('employee_id');
                                      sharedPreferences
                                          .remove('employee_department');
                                      sharedPreferences.remove('user_type');
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 400),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              LoginView(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(-1, 0.0);
                                            const end = Offset.zero;
                                            final tween =
                                                Tween(begin: begin, end: end);
                                            final offsetAnimation =
                                                animation.drive(tween);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text('Log Out')),
                                PopupMenuItem(
                                    value: 'Main Menu',
                                    padding: const EdgeInsets.only(left: 25),
                                    height: 10,
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 400),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              const AppNavigation(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(-1, 0.0);
                                            const end = Offset.zero;
                                            final tween =
                                                Tween(begin: begin, end: end);
                                            final offsetAnimation =
                                                animation.drive(tween);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text('Main Menu')),
                              ];
                            },
                            child: const Icon(Icons.power_settings_new_sharp),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Consumer<UserDataProvider>(
                key: calendarKey,
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return SizedBox(
                      width: size.width * 0.95,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0, top: 4),
                              child: Text('Lunch Calendar'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 18),
                              child: Text(
                                '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                                height: size.height * 0.37,
                                child: CustomWidgets.CustomCircularLoader()),
                          ],
                        ),
                      ),
                    );
                  } else if (provider.eventsPresent) {
                    return CustomCalendarCard(
                      controller: datesController,
                      forAdmin: false,
                      isUDP: true,
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectibleDayPredicate: (date) {
                        return date.toString().substring(0, 10) ==
                                now.toString().substring(0, 10) &&
                            ![DateTime.saturday, DateTime.sunday]
                                .contains(date.weekday) &&
                            !Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .holidays
                                .contains(date.toString().substring(0, 10)) &&
                            !Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .getNotOpted
                                .map((e) => e.date)
                                .toList()
                                .contains(date.toString().substring(0, 10)) &&
                            !Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .getOpted
                                .contains(date.toString().substring(0, 10));
                      },
                      onSubmit: (date) {
                        if (date == null) {
                          CustomWidgets.CustomSnackBar(
                              context,
                              'Please select today'
                              's date',
                              Colors.red);
                        } else if ((now.hour >= 15)) {
                          CustomWidgets.CustomSnackBar(
                              context, "QR is disabled after 3pm", Colors.red);
                        } else if ((now.hour < 12 ||
                            (now.hour == 12 && now.minute < 30))) {
                          CustomWidgets.CustomSnackBar(context,
                              "Wait till 12.30pm to get QR", Colors.red);
                        } else {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Preview(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      },
                      onCancel: () {
                        datesController.selectedDate = null;
                      },
                      confirmText: 'Ok',
                      cancelText: 'Cancel',
                    );
                  } else {
                    return SizedBox(
                      width: size.width * 0.95,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0, top: 4),
                              child: Text('Lunch Calendar'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 18),
                              child: Text(
                                '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              height: size.height * 0.37,
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () {
                                    Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .setConnected(isConnected());
                                    if (!Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .getConnected) {
                                      CustomWidgets.CustomSnackBar(context,
                                          'No Internet Connection', Colors.red);
                                    } else {
                                      setState(() {
                                        Provider.of<UserDataProvider>(context,
                                                listen: false)
                                            .setConnected(isConnected());
                                        widget.initData!;
                                        Provider.of<UserDataProvider>(context,
                                                listen: false)
                                            .isLoading = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              CustomLegend(
                key: legendKey,
              ),
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.73,
                child: Card(
                  key: updateUpcomingLunchStatusKey,
                  color: const Color.fromRGBO(241, 232, 255, 1),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  UpdateLunchStatus(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        const Text(
                          'Update upcoming lunch status',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        const Icon(Icons.keyboard_arrow_right_rounded)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Image.asset('assets/images/food.png'),
            ],
          ),
        ),
      ),
    );
  }
}

/*
from company's employee table we required fields like
1. Employee name,
2. Employee id,
3. User Type (E -> Employee, A -> Admin, V -> Vendor),
(we only get data from this table when user enters into app)

fields for events table ({mail id, date} can be a composite primary key)
1. Employee mail id
2. Date
3. Status => opted or not opted, no status if user dont eat and not updated date in not opted list
4. Info => scan time for scanned , reason for not opted, empty for not status
(we get and post the data when user's QR is scanned or when he updates single or multiple dates as not opted in update upcoming status)

holidays table
1. date 
(we only get data from this table when user enters into this table)
*/
