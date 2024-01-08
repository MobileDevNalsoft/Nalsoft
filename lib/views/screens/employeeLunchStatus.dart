import "package:flutter/material.dart";
import 'package:mess_management/views/screens/route_management.dart';
import 'package:mess_management/views/widgets/infoCard.dart';
import "package:table_calendar/table_calendar.dart";

void main() {
  runApp(MaterialApp(
    home: EmployeeLunchStatus(),
  ));
}

class EmployeeLunchStatus extends StatelessWidget {
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
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
            child:InfoCard(content: {"Employee Name":"Peter Parker","Department":"Engineering","Floor":"8"} as Map<String,String>,)
            //  Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Employee name",
            //           style: TextStyle(color: Colors.black54, fontSize: 16),
            //         ),
            //         Text(
            //           "Department",
            //           style: TextStyle(color: Colors.black54, fontSize: 16),
            //         ),
            //         Text(
            //           "Floor",
            //           style: TextStyle(color: Colors.black54, fontSize: 16),
            //         )
            //       ],
            //     ),
            //     Column(
            //       children: [Text(":"), Text(":"), Text(":")],
            //     ),
            //     Column(
            //       children: [
            //         Text("Peter Parker",
            //             style: TextStyle(
            //                 color: Colors.black87,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold)),
            //         Text("Engineering",
            //             style: TextStyle(
            //                 color: Colors.black87,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold)),
            //         Text("8",
            //             style: TextStyle(
            //                 color: Colors.black87,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold))
            //       ],
            //     )
            //   ],
            // ),
          
          ),
          LunchStatusCalender(),
          Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(context, RouteManagement.download);
          }, child: Text("Generate CSV")),
          Image.asset("assets/images/food.png"),
        ],
      ),
    ));
  }
}

class LunchStatusCalender extends StatelessWidget {
  LunchStatusCalender({super.key});
  Map<DateTime, String> _events = {
    DateTime.utc(2024, 1, 15): 'opted',
    DateTime.utc(2024, 1, 25): 'not opted',
    DateTime.utc(2024, 1, 26): 'holiday',
  };
  var currentDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      
    decoration: BoxDecoration(color: Color.fromRGBO(236, 230, 240, 100),borderRadius: BorderRadius.circular(25)),
      width: MediaQuery.of(context).size.width*0.9,
      child: TableCalendar(
        // rowHeight: 80,
        
        currentDay: DateTime.now(),
        focusedDay: DateTime.now(),
        firstDay: DateTime(2023),
        lastDay: DateTime(2025),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 18),
          leftChevronIcon: Icon(Icons.chevron_left),
          rightChevronIcon: Icon(Icons.chevron_right),
        ),
      
        holidayPredicate: (day) {
          if (_events.containsKey(day)) return true;
          return false;
        },
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black),
          weekendStyle: TextStyle(color: Colors.black),
        ),
      
        calendarStyle: CalendarStyle(
          holidayTextStyle: TextStyle(color: Colors.black),
          todayDecoration: BoxDecoration(
            color: Color.fromARGB(255, 130, 182, 231),
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          weekendDecoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade100),
        ),
      
        onDaySelected: (selectedDay, focusedDay) {
          if (selectedDay.day == currentDay.day &&
              !_events.containsKey(selectedDay)) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("${selectedDay}${focusedDay}"),
                  );
                });
          }
        },
        calendarBuilders: CalendarBuilders(
          holidayBuilder: (context, day, focusedDay) {
            if (_events.containsKey(day)) {
              if (_events[day] == "opted") {
                return Container(
                  decoration:
                      BoxDecoration(color: const Color.fromARGB(255, 111, 211, 114), shape: BoxShape.circle),
                  width: 42,
                  child: Center(
                    child: Text("${day.day}"),
                  ),
                );
              } else if (_events[day] == "not opted") {
                return Container(
                  decoration:
                      BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                  width: 42,
                  child: Center(
                    child: Text("${day.day}"),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
