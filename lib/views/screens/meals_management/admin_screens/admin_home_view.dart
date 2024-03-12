import "dart:io";
import "package:custom_widgets/src.dart";
import "package:get_it/get_it.dart";
import "package:meals_management/inits/di_container.dart";
import "package:meals_management/models/user_model.dart";
import "package:meals_management/network_handler_mixin/network_handler.dart";
import "package:meals_management/utils/constants.dart";
import "package:meals_management/views/custom_widgets/custom_calendar_card.dart";
import "package:meals_management/views/in_app_tour.dart";
import "package:meals_management/views/screens/meals_management/admin_screens/admin_employees_view.dart";
import "package:meals_management/views/screens/meals_management/admin_screens/admin_generate_notification_view.dart";
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:meals_management/providers/meals_management/admin_employees_provider.dart";
import "package:meals_management/providers/meals_management/user_data_provider.dart";
import "package:meals_management/route_management/route_management.dart";
import "package:meals_management/views/custom_widgets/custom_snackbar.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "package:tutorial_coach_mark/tutorial_coach_mark.dart";

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with ConnectivityMixin {
  DateTime now = DateTime.now();

  late SharedPreferences sharedPreferences;

  DateRangePickerController datesController = DateRangePickerController();

  String qrResult = '';

  final calendarKey = GlobalKey();
  final searchEmployeeKey = GlobalKey();
  final notifyKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void _initAddSiteInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addAdminHomeSiteTargets(
        calendarKey: calendarKey,
        searchEmployeeKey: searchEmployeeKey,
        notifyKey: notifyKey,
      ),
      colorShadow: Colors.black12,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      onFinish: () {
        print('admin home tutorial completed');
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        tutorialCoachMark.show(context: context);
        sharedPreferences.setBool('hasSeenTutorial4', true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    sharedPreferences = GetIt.instance.get<SharedPreferences>();
    Provider.of<AdminEmployeesProvider>(context, listen: false)
        .setAllUserList();
    if (!sharedPreferences.containsKey('hasSeenTutorial4')) {
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
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                              width: size.width * 0.6,
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
                            sharedPreferences.getString('user_type') == 'A'
                                ? Switch(
                                    value: true,
                                    onChanged: (value) {
                                      Navigator.pop(context,
                                          RouteManagement.employeeHomePage);
                                    },
                                    activeColor: const Color.fromARGB(
                                        255, 181, 129, 248),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, top: 10, left: 10),
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                        value: 'Log Out',
                                        height: 10,
                                        padding: EdgeInsets.only(left: 25),
                                        onTap: () {
                                          init();
                                          sharedPreferences
                                              .remove('employee_name');
                                          sharedPreferences
                                              .remove('employee_id');
                                          sharedPreferences
                                              .remove('employee_department');
                                          sharedPreferences.remove('user_type');
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RouteManagement.loginPage,
                                          );
                                        },
                                        child: const Text('Log Out'))
                                  ];
                                },
                                child:
                                    const Icon(Icons.power_settings_new_sharp),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.92,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromRGBO(236, 230, 240, 100),
                    ),
                    child: InkWell(
                      onTap: () {
                        Provider.of<UserDataProvider>(context, listen: false)
                            .setConnected(isConnected());
                        if (Provider.of<UserDataProvider>(context,
                                listen: false)
                            .getConnected)
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 200),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      EmployeeSearch(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0, 0.2);
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
                        else {
                          CustomSnackBar.showSnackBar(
                              context, "No internet", Colors.red);
                        }
                      },
                      child: Row(
                        key: searchEmployeeKey,
                        children: [
                          const Icon(Icons.groups),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          const Expanded(
                              child: Text("Search employee",
                                  style: TextStyle(
                                      color: Color.fromRGBO(73, 69, 79, 100)))),
                          const Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                  const Text("Select Date",
                      style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100))),
                  CustomCalendarCard(
                    key: calendarKey,
                    forAdmin: true,
                    isUDP: true,
                    controller: datesController,
                    selectionMode: DateRangePickerSelectionMode.single,
                    selectibleDayPredicate: (date) {
                      return ((date.weekday != DateTime.saturday &&
                                  date.weekday != DateTime.sunday &&
                                  date.day <= now.day &&
                                  date.month == now.month) ||
                              (date.weekday != DateTime.saturday &&
                                  date.weekday != DateTime.sunday &&
                                  date.month < now.month)) &&
                          !Provider.of<UserDataProvider>(context, listen: false)
                              .holidays
                              .contains(date.toString().substring(0, 10));
                    },
                    onSubmit: (date) {
                      if (date != null) {
                        date = date as DateTime;
                        isConnected()
                            ? sendMail(date, context)
                            : CustomSnackBar.showSnackBar(
                                context, "No internet", Colors.red);
                      } else {
                        CustomSnackBar.showSnackBar(
                            context, 'please select a date', Colors.red);
                      }
                    },
                    onCancel: () {
                      datesController.selectedDate = null;
                      datesController.selectedDates = null;
                    },
                    confirmText: 'Send Mail',
                    cancelText: 'Clear Selection',
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  CustomWidgets.CustomElevatedButton(
                      key: notifyKey,
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade300),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 200),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    GenerateNotification(),
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
                      child: const Text(
                        "Notify",
                        style: TextStyle(color: Colors.black),
                      )),
                  Image.asset("assets/images/food.png")
                ],
              ),
              if (Provider.of<AdminEmployeesProvider>(context, listen: true)
                  .isMailLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      color: Colors.black38,
                      child: CustomWidgets.CustomCircularLoader()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMail(DateTime date, BuildContext context) async {
    Provider.of<AdminEmployeesProvider>(context, listen: false).isMailLoading =
        true;

    await Provider.of<AdminEmployeesProvider>(context, listen: false)
        .getAllUsers(date.toString().substring(0, 10));

    List<dynamic> empData =
        Provider.of<AdminEmployeesProvider>(context, listen: false)
            .getAllUserList!;

    final dir = await getTemporaryDirectory();

    // Create a new Excel workbook
    final excel.Workbook workbook = excel.Workbook();

    // Add a worksheet to the workbook
    final excel.Worksheet sheet = workbook.worksheets[0];

    excel.Style style = workbook.styles.add('style');

    style.wrapText = true;
    style.borders.all.lineStyle = excel.LineStyle.double;
    sheet.getRangeByIndex(2, 1).builtInStyle = excel.BuiltInStyles.heading4;
    sheet.getRangeByIndex(2, 2).builtInStyle = excel.BuiltInStyles.heading4;
    sheet.getRangeByIndex(2, 3).builtInStyle = excel.BuiltInStyles.heading4;
    sheet.getRangeByIndex(2, 4).builtInStyle = excel.BuiltInStyles.heading4;

    // Set the worksheet name
    sheet.name = 'Today\'s Meals opted employees';

    // Append headers
    sheet.getRangeByIndex(1, 3).setText(date.toString().substring(0, 10));
    sheet.getRangeByIndex(2, 1).setText('Employee ID');
    sheet.getRangeByIndex(2, 2).setText('Employee Name');
    sheet.getRangeByIndex(2, 3).setText("Status");
    sheet.getRangeByIndex(2, 4).setText('Remarks');

    // Append data
    int rowIndex = 3;
    for (var data in empData) {
      Data userdata = data;
      sheet.getRangeByIndex(rowIndex, 1).setText(userdata.empId);
      sheet.getRangeByIndex(rowIndex, 2).setText(userdata.empName);
      sheet.getRangeByIndex(rowIndex, 3).setText(userdata.status);
      if (userdata.status == '1') {
        userdata.info =
            DateTime.fromMillisecondsSinceEpoch(int.parse(userdata.info!))
                .toString()
                .substring(11, 19);
      }
      sheet.getRangeByIndex(rowIndex, 4).setText(userdata.info);
      rowIndex++;
    }

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);
    sheet.autoFitColumn(4);

    try {
      // Save the workbook to external storage
      final List<int> bytes = workbook.saveAsStream();

      final path = '${dir!.path}/mess_data_$now.xlsx';
      final File file = File(path);
      await file.writeAsBytes(bytes);

      // Print debug information
      print('File saved at: $path');

      // Check email permissions
      var status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
      }

      // Permission granted, proceed with sending email
      String recipientEmail =
          sharedPreferences.getString(AppConstants.USERNAME).toString();
      const subject = 'Excel Data';
      const body = 'Please find the attached Excel file with the data.';

      final email = Email(
        body: body,
        subject: subject,
        recipients: [recipientEmail],
        attachmentPaths: [path],
      );
      Provider.of<AdminEmployeesProvider>(context, listen: false)
          .isMailLoading = false;

      // Send email
      await FlutterEmailSender.send(email);
    } catch (error) {
      // Handle the error
      print('Error sending email: $error');
    }
  }
}
