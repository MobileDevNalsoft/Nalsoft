import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/admin_download_csv_provider.dart';

// ignore: must_be_immutable
class Download extends StatelessWidget {

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  Download({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text("Lunch Status"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {

          }, icon: const Icon(Icons.account_circle_rounded))
        ],
        backgroundColor: const Color.fromRGBO(236, 230, 240, 100),
        elevation: 4,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Column(
        children: [
          const Padding(
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
          const SizedBox(height: 24.0),
          dateRangeCalender(_startDateController, _endDateController),
          const SizedBox(height: 24.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Consumer<DownloadProvider>(builder: (context, provider, child) {
              return ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_startDateController.text.isNotEmpty) {
                    provider.updateDateRange(startDate:_startDateController.text);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Downloaded")));
                  }
                  else{
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Start date cannot be empty")));
                  }
                },
                child: const Row(
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
          const Expanded(child: SizedBox()),
          Image.asset("assets/images/food_png.png"),
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
            color: const Color.fromRGBO(247, 242, 250, 100)),
        width: width * 0.8,
        height: height * 0.28,
        child: Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Text("Select date range"),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Enter dates",
                  style: TextStyle(fontSize: 24),
                ),
                Icon(Icons.calendar_month)
              ],
            ),
            const Divider(),
            const SizedBox(
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
                      label: const Text("Start date"),
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
                        label: const Text("End date")),
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
