import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:meals_management_with_firebase/models/user_model.dart";
import "package:meals_management_with_firebase/providers/employee_lunch_status_provider.dart";
import "package:meals_management_with_firebase/providers/events_provider.dart";
import "package:meals_management_with_firebase/providers/user_data_provider.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class EmployeeLunchStatus extends StatefulWidget {
  String? empid;

  EmployeeLunchStatus({super.key, this.empid});

  @override
  State<EmployeeLunchStatus> createState() => _EmployeeLunchStatusState();
}

class _EmployeeLunchStatusState extends State<EmployeeLunchStatus> {
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Future<void> initData() async {
    String empid = widget.empid!;
    try {
      await Provider.of<EmployeeLunchStatusProvider>(context, listen: false)
          .getOptedFromDB(empid: empid);
      await Provider.of<EmployeeLunchStatusProvider>(context, listen: false)
          .getNotOptedFromDB(empid: empid);
      await Provider.of<EmployeeLunchStatusProvider>(context, listen: false)
          .getNotOptedWithReasonsFromDB(empid: empid);
      await Provider.of<EmployeeLunchStatusProvider>(context, listen: false)
          .setUser(empid: empid);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    UserModel? user =
        Provider.of<EmployeeLunchStatusProvider>(context, listen: false)
            .getUser;

    Map<DateTime, String> dates =
        Provider.of<EmployeeLunchStatusProvider>(context, listen: false)
            .getNotOptedWithReasons;

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Text(
                            "Department",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Text(
                            "Floor",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [Text(":"), Text(":"), Text(":")],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user!.userName,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(user.department,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(user.floor,
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
                  height: size.height * 0.4,
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
                            bool isOpted =
                                Provider.of<EmployeeLunchStatusProvider>(
                                        context,
                                        listen: false)
                                    .getOpted
                                    .contains(details.date);
                            bool isNotOpted =
                                Provider.of<EmployeeLunchStatusProvider>(
                                        context,
                                        listen: false)
                                    .getNotOpted
                                    .contains(details.date);
                            Color circleColor = isOpted
                                ? Colors.green.shade200
                                : isNotOpted
                                    ? Colors.orange.shade200
                                    : (details.date.weekday ==
                                                DateTime.sunday ||
                                            details.date.weekday ==
                                                DateTime.saturday)
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
                                child: Center(
                                    child: Text(details.date.day.toString())),
                              ),
                            );
                          },
                          allowViewNavigation: true,
                          selectionMode: DateRangePickerSelectionMode.single,
                          showNavigationArrow: true,
                          onSelectionChanged:
                              (dateRangePickerSelectionChangedArgs) {
                            if (dates.keys.contains(
                                dateRangePickerSelectionChangedArgs.value)) {
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
                                            Text(dates[
                                                dateRangePickerSelectionChangedArgs
                                                    .value]!),
                                          ],
                                        )),
                                  );
                                },
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Image.asset("assets/images/food_png.png"),
              ],
            ),
    ));
  }
}
