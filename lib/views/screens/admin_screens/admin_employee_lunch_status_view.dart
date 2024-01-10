import "package:flutter/material.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class EmployeeLunchStatus extends StatelessWidget {
  
  const EmployeeLunchStatus({super.key});

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text("Lunch Status"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_box_rounded))
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
          SizedBox(
            height: size.height*0.4,
            width: size.width*0.95,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              elevation: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SfDateRangePicker(
                        showActionButtons: true,
                        allowViewNavigation: true,
                        selectionMode: DateRangePickerSelectionMode.single,
                        showNavigationArrow: true,
                      )
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
            Navigator.pushNamed(context, '/download_csv');
          }, child: const Text("Generate CSV")),
          Image.asset("assets/images/food_png.png"),
        ],
      ),
    ));
  }
}

