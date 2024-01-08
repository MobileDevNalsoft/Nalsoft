import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mess_management/providers/downloadProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    home: SafeArea(
      child: ChangeNotifierProvider<DownloadProvider>(
        create: (context) => DownloadProvider(),
        child: Download(),
      ),
    ),
  ));
}

class Download extends StatelessWidget {
  var _startDateController = TextEditingController();
  var _endDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: const Text("Lunch Status"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_rounded))
        ],
        backgroundColor: Color.fromRGBO(236, 230, 240, 100),
        elevation: 4,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Column(
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
                  children: [
                    Text("Peter Parker",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text("Engineering",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text("8",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 24.0),
          dateRangeCalender(_startDateController, _endDateController),
          SizedBox(height: 24.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Consumer<DownloadProvider>(builder: (context, provider, child) {
              return ElevatedButton(
                onPressed: () {
                    FocusScope.of(context).unfocus();
                  if (_startDateController.text.length != 0) {
                   provider.updateDateRange(startDate:_startDateController.text);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Downloaded")));
                  }
                  else{
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Start date cannot be empty")));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.download),
                    Text(
                      "Download CSV",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              );
            }),
          ),
          Expanded(child: SizedBox()),
          Image.asset("assets/images/food.png"),
        ],
      ),
    );
  }
}

class dateRangeCalender extends StatelessWidget {
  var size, height, width;

  var _startDateController;
  var _endDateController;

  dateRangeCalender(this._startDateController, this._endDateController,
      {super.key});
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Color.fromRGBO(247, 242, 250, 100)),
        width: width * 0.8,
        height: height * 0.28,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Text("Select date range"),
              ],
            ),
            SizedBox(
              height: 32.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Enter dates",
                  style: TextStyle(fontSize: 24),
                ),
                Icon(Icons.calendar_month)
              ],
            ),
            Divider(),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.35,
                  child: TextField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      hintText: "dd/mm/yyyy",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      alignLabelWithHint: true,
                      label: Text("Start date"),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.35,
                  child: TextField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                        hintText: "dd/mm/yyyy",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        alignLabelWithHint: true,
                        label: Text("End date")),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
