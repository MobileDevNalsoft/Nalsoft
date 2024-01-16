import "dart:io";
import "package:excel/excel.dart";
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:intl/intl.dart";
import "package:meals_management_with_firebase/models/user_model.dart";
import "package:meals_management_with_firebase/providers/admin_employees_provider.dart";
import "package:meals_management_with_firebase/providers/user_data_provider.dart";
import "package:meals_management_with_firebase/views/custom_widgets/custom_snackbar.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "../../../providers/employee_home_provider.dart";
import '../../../repositories/firebase_auth_repo.dart';

// ignore: must_be_immutable
class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  late SharedPreferences sharedPreferences;

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    DateRangePickerController datesController = DateRangePickerController();

    UserModel? user =
        Provider.of<UserDataProvider>(context, listen: false).getUser;

    return SafeArea(
      child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<EmployeeHomeProvider>(
                          builder: (context, provider, child) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 25, top: 15),
                              child: Text(
                                'Hi,\n${user!.userName}',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                        const Expanded(child: SizedBox()),
                        Consumer<EmployeeHomeProvider>(
                          builder: (context, provider, child) {
                            return user!.isAdmin
                                ? Switch(
                                    value: true,
                                    onChanged: (value) {
                                      Navigator.pushReplacementNamed(
                                          context, '/emp_homepage');
                                    },
                                    activeColor: const Color.fromARGB(
                                        255, 181, 129, 248),
                                  )
                                : const SizedBox();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                    value: 'Sign Out',
                                    height: 10,
                                    onTap: () => FirebaseAuthRepo()
                                            .signOutNow()
                                            .then((value) {
                                          sharedPreferences!
                                              .setString("islogged", 'false');
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/login_page",
                                              (route) => false);
                                        }),
                                    child: const Text('Sign Out'))
                              ];
                            },
                            child: const Icon(Icons.power_settings_new_sharp),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(236, 230, 240, 100),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin_employees');
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.groups),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            const Expanded(
                                child: Text("Search employee",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(73, 69, 79, 100)))),
                            const Icon(Icons.search),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Text("Select Date",
                      style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100))),
                  SizedBox(
                    width: size.width * 0.95,
                    height: size.height * 0.5,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 4),
                            child: Text('Lunch Calendar'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 18),
                            child: Text(
                              '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                          const Divider(),
                          Consumer<EmployeeHomeProvider>(
                            builder: (context, provider, child) {
                              return Expanded(
                                child: SfDateRangePicker(
                                    controller: datesController,
                                    selectionColor: Colors.deepPurple.shade200,
                                    selectionShape: DateRangePickerSelectionShape.circle,
                                    cellBuilder: (BuildContext context, DateRangePickerCellDetails details) {
                                        Color circleColor = (details.date.weekday == DateTime.sunday || details.date.weekday == DateTime.saturday) ? Colors.blueGrey.shade200 : Colors.white30;
                                        return Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Container(
                                              width: details.bounds.width/2,
                                              height: details.bounds.width/2,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: circleColor,
                                              ),
                                              child: Center(child: Text(details.date.day.toString())),
                                            ),
                                        );
                                      },
                                    showActionButtons: true,
                                    allowViewNavigation: true,
                                    selectionMode:DateRangePickerSelectionMode.single,
                                    showNavigationArrow: true,
                                    confirmText: 'Send Mail',
                                    cancelText: 'Clear Selection',
                                    onSubmit: (date) {
                                      if(date != null){
                                        date = date as DateTime;
                                        sendMail(date, context);
                                      }else{
                                        CustomSnackBar.showSnackBar(context, 'please select a date');
                                      }
                                    },
                                    onCancel: () {
                                      datesController.selectedDate = null;
                                      datesController.selectedDates = null;
                                    },
                                  )
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Image.asset("assets/images/food_png.png")
                ],
              ),
            ),
    );
  }

  Future<void> sendMail(DateTime date, BuildContext context) async{
    List<Map<String,dynamic>> empData = Provider.of<AdminEmployeesProvider>(context, listen: false).getEmpData;
    List<String?> optedEmployees = empData.map((e) {
      if(e['opted'] != null){
        if(e['opted'].contains(date.toString())){
        return e['username'] as String;
      }
      }
    }).nonNulls.toList();
    //creating excel 

    var excel = Excel.createExcel();
    Sheet sheet = excel['Today''s Meals opted employees'];

    sheet.appendRow([TextCellValue('Employees opted today')]);

    for(int i = 0; i < optedEmployees.length ;i ++){
      List<String?> rowData = [optedEmployees[i]];
      List<CellValue> name = rowData.map((e) => TextCellValue(e!)).toList();
      sheet.appendRow(name);
    }

    sheet.appendRow([TextCellValue('${optedEmployees.length}'),TextCellValue('Number of employees opted today')]);

    final bytes = excel.encode();

    // Request storage permission if needed
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
    // Permission granted, proceed with storage operations
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/mess_data.xlsx';
    File(path).writeAsBytes(bytes!);
    const recipientEmail = 'chiluverimadhankumarnetha@gmail.com';
    const subject = 'Excel Data';
    const body = 'Please find the attached Excel file with the data.';
    final excelFile =  File(path);

    final email = Email(
    body: body,
    subject: subject,
    recipients: [recipientEmail],
    attachmentPaths: [excelFile.path],
    );

    try {
      await FlutterEmailSender.send(email);
      CustomSnackBar.showSnackBar(context, 'Email sent successfully');
    } catch (error) {
      print('Error sending email: $error');
      // Handle the error appropriately, e.g., display an error message to the user
    }
    
  }
}
