import "dart:io";
import 'package:http/http.dart' as http;
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:meals_management/models/user_model.dart";
import "package:meals_management/providers/admin_employees_provider.dart";
import "package:meals_management/providers/user_data_provider.dart";
import "package:meals_management/views/custom_widgets/custom_snackbar.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart" as excel;

class EmployeeLunchStatus extends StatefulWidget {
  String? empid;

  EmployeeLunchStatus({super.key, this.empid});

  @override
  State<EmployeeLunchStatus> createState() => _EmployeeLunchStatusState();
}

class _EmployeeLunchStatusState extends State<EmployeeLunchStatus> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    String empid = widget.empid!;

    Map<String, dynamic> thisEmpData =
        Provider.of<AdminEmployeesProvider>(context, listen: false)
            .getAllEmpData
            .where(
              (element) => element['employee_id'] == empid,
            )
            .first;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Lunch Status"),
        centerTitle: true,
        actions: [
          Icon(
            Icons.account_circle_sharp,
            size: 30,
          ),
          SizedBox(
            width: 10,
          )
        ],
        backgroundColor: const Color.fromRGBO(236, 230, 240, 100),
        elevation: 4,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Employee name",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(
                      "Department",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    )
                  ],
                ),
                Column(
                  children: [Text(":"), Text(":"), Text(":")],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(thisEmpData['username'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(thisEmpData['department'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(thisEmpData['floor'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.45,
            width: size.width * 0.95,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              elevation: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SfDateRangePicker(
                    selectionColor: Colors.deepPurple.shade200,
                    selectionShape: DateRangePickerSelectionShape.circle,
                    cellBuilder: (BuildContext context,
                        DateRangePickerCellDetails details) {
                      bool isOpted = thisEmpData['opted']
                          .keys
                          .contains(details.date.toString());
                      bool isNotOpted = thisEmpData['notOpted']
                          .keys
                          .contains(details.date.toString());
                      Color circleColor = isOpted
                          ? Colors.green.shade200
                          : isNotOpted
                              ? Colors.orange.shade200
                              : (details.date.weekday == DateTime.sunday ||
                                      details.date.weekday == DateTime.saturday)
                                  ? Colors.blueGrey.shade200
                                  : Colors.white30;
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          width: details.bounds.width / 2,
                          height: details.bounds.width / 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                          child:
                              Center(child: Text(details.date.day.toString())),
                        ),
                      );
                    },
                    allowViewNavigation: true,
                    selectionMode: DateRangePickerSelectionMode.single,
                    showNavigationArrow: true,
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      if (thisEmpData['notOpted'].keys.contains(
                          dateRangePickerSelectionChangedArgs.value
                              .toString())) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                  width: size.width * 0.6,
                                  height: size.height * 0.08,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reason',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Text(thisEmpData['notOpted'][
                                          dateRangePickerSelectionChangedArgs
                                              .value
                                              .toString()]!),
                                    ],
                                  )),
                            );
                          },
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () => sendMail(context, thisEmpData),
                        child: Text('Send Mail'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Image.asset("assets/images/food.png"),
        ],
      ),
    ));
  }

  Future<void> sendMail(
      BuildContext context, Map<String, dynamic> thisEmpData) async {
    final dir = await getExternalStorageDirectory();

    // Create a new Excel workbook
    final excel.Workbook workbook = excel.Workbook();

    // Add a worksheet to the workbook
    final excel.Worksheet sheet = workbook.worksheets[0];

    excel.Style style = workbook.styles.add('style');

    style.wrapText = true;

    // Set the worksheet name
    sheet.name = '${thisEmpData['username']}' 's Meals data';

    // Append headers
    sheet
        .getRangeByIndex(1, 1)
        .setText('${thisEmpData['username']}(${thisEmpData['employee_id']})');

    sheet.getRangeByIndex(3, 1).setText('Opted Dates');
    sheet.getRangeByIndex(3, 2).setText('Signature');
    sheet.getRangeByIndex(3, 4).setText('NotOpted Dates');
    sheet.getRangeByIndex(3, 5).setText('Reason');

    // Append data
    int rowIndex = 4;
    for (var entry in thisEmpData['opted'].entries) {
      sheet.getRangeByIndex(rowIndex, 1).setText(entry.key.substring(0, 10));
      final response = await http.get(Uri.parse(entry.value));
      final excel.Picture picture =
          sheet.pictures.addStream(rowIndex, 2, response.bodyBytes);
      picture.height = 20;
      picture.width = 50;
      rowIndex++;
    }
    rowIndex = 4;
    for (var entry in thisEmpData['notOpted'].entries) {
      sheet.getRangeByIndex(rowIndex, 4).setText(entry.key.substring(0, 10));
      sheet.getRangeByIndex(rowIndex, 5).setText(entry.value);
      rowIndex++;
    }

    try {
      // Save the workbook to external storage
      final List<int> bytes = workbook.saveAsStream();

      final path =
          '${dir!.path}/${thisEmpData['username']}_mess_data_${DateTime.now()}.xlsx';
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
      const recipientEmail = 'chiluverimadhankumarnetha@gmail.com';
      const subject = 'Excel Data';
      const body = 'Please find the attached Excel file with the data.';

      final email = Email(
        body: body,
        subject: subject,
        recipients: [recipientEmail],
        attachmentPaths: [path],
      );

      // Send email
      await FlutterEmailSender.send(email);

      // Show success message
      CustomSnackBar.showSnackBar(context, 'Email sent successfully');
    } catch (error) {
      // Handle the error
      print('Error sending email: $error');
      CustomSnackBar.showSnackBar(context, 'Error sending email: $error');
    }
  }
}
