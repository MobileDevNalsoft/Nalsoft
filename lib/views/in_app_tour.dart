import 'package:flutter/material.dart';
import 'package:meals_management/inits/di_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> addAppNavigationSiteTargets({
  required GlobalKey mealsAppkey,
  required GlobalKey meetingsAppkey,
}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      keyTarget: mealsAppkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tap on this to explore Meals Management Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: meetingsAppkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tap on this to explore Meetings Management Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}

List<TargetFocus> addEmployeeHomeSiteTargets({
  required GlobalKey calendarKey,
  required GlobalKey legendKey,
  required GlobalKey updateUpcomingLunchStatusKey,
  required GlobalKey notificationsKey,
  required GlobalKey toggleKey,
  required GlobalKey logoutKey,
}) {
  List<TargetFocus> targets = [];

  final sharedPreferences = sl.get<SharedPreferences>();

  targets.add(TargetFocus(
      keyTarget: calendarKey,
      alignSkip: Alignment.bottomRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Track your meals status using the color codes shown in this calendar, Select todays date and click on "Ok" to generate QR',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: legendKey,
      alignSkip: Alignment.bottomRight,
      radius: 8,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'For clarification, compare this legend with the color codes from the calendar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: updateUpcomingLunchStatusKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Click on this button to Update your upcoming lunch status',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: notificationsKey,
      alignSkip: Alignment.bottomRight,
      radius: 6,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Click on this bell icon to view Notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  if (sharedPreferences.getString('user_type') == 'A') {
    targets.add(TargetFocus(
        keyTarget: toggleKey,
        alignSkip: Alignment.bottomRight,
        radius: 10,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'toggle this to enter into Admin Mode',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              );
            },
          )
        ]));
  }

  targets.add(TargetFocus(
      keyTarget: logoutKey,
      alignSkip: Alignment.bottomRight,
      radius: 6,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Click on this to logout or go back to Main Menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}

List<TargetFocus> addUpdateUpcomingLunchStatusSiteTargets({
  required GlobalKey dropDownKey,
  required GlobalKey calendarKey,
}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      keyTarget: dropDownKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Click on this to view dropdown and select Single day mode or Multiple days mode',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: calendarKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select dates from the calendar corresponding to the selection mode in dropdown, then click on "Ok" and act accordingly',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}

List<TargetFocus> addAdminHomeSiteTargets(
    {required GlobalKey searchEmployeeKey,
    required GlobalKey calendarKey,
    required GlobalKey notifyKey}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      keyTarget: searchEmployeeKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tap on this to search for employees',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: calendarKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select a date and Click on "Send Mail" to get track of all employees meals status for that particular day',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: notifyKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Click on this button and you will be navigated to Generate Notifications page',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}

List<TargetFocus> addSearchEmployeeSiteTargets(
    {required GlobalKey searchEmployeeKey}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      keyTarget: searchEmployeeKey,
      alignSkip: Alignment.centerRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Enter aleast 4 characters to search for an employee, then click on the name of desired employee to track his/her meals status individually',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}

List<TargetFocus> addEmployeeLunchStatusSiteTargets(
    {required GlobalKey calendarKey}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      keyTarget: calendarKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Click on "Send Mail" to get the present month meals status of this employee',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}
