import 'package:flutter/material.dart';
import 'package:custom_widgets/src.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/meeting_rooms_management/home_view_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:provider/provider.dart';

class CheckAvailabilty extends StatefulWidget {
  @override
  State<CheckAvailabilty> createState() => _CheckAvailabiltyState();
}

class _CheckAvailabiltyState extends State<CheckAvailabilty> {
  final PageController _floorPageController = PageController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: AspectRatio(
      aspectRatio: size.height / size.width,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.024,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Today, 28th Feb 2024",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 24,
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Time",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "End Time",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Number Of Participants",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(":"), Text(":"), Text(":")],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "12:30",
                      style: TextStyle(fontSize: 18),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "13:30",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Text(
                      "6",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            CustomWidgets.CustomElevatedButton(
              onPressed: () {},
              child: Text(
                "Check Availability",
                style: TextStyle(color: Colors.black),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    18.0), // Adjust the value for desired border radius
              )),
              minimumSize: MaterialStateProperty.all(
                  Size(size.width * 0.3, size.height * 0.05)),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blueGrey.shade100;
                } else if (states.contains(MaterialState.hovered)) {
                  return Colors.blueGrey.shade400;
                }
                // Default color
                return Colors.blueGrey.shade400;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "Rooms Available",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            Consumer<HomeViewProvider>(builder: (context, provider, child) {
              return Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        {0: 1},
                        {1: 8},
                        {2: 9}
                      ]
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8, bottom: 8),
                                child: SizedBox(
                                  height: 24,
                                  width: 85,
                                  child: CustomWidgets.CustomElevatedButton(
                                    onPressed: () {
                                      _floorPageController
                                          .jumpToPage(e.keys.first);
                                    },
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          6.0), // Adjust the value for desired border radius
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        provider.getCheckAvailabilityCurrentFloorPage ==
                                                e.keys.first
                                            ? Colors.blueGrey.shade500
                                            : Colors.blueGrey.shade200),
                                    child: Text(
                                      'Floor ${e.values.first}',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color:
                                              provider.getCheckAvailabilityCurrentFloorPage ==
                                                      e.keys.first
                                                  ? Colors.white
                                                  : Colors.black),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()),
                  Text("Room's Status"),
                  SizedBox(
                      height: size.height * 0.56,
                      width: size.width * 0.9,
                      child: PageView(
                        controller: _floorPageController,
                        onPageChanged: (int page) {
                          provider.setCheckAvailabilityCurrentFloorPage = page;
                        },
                        children: [1, 8, 9]
                            .map((e) => FloorPage(
                                floor: e, provider: provider, size: size))
                            .toList(),
                      ))
                ],
              );
            }),
          ],
        ),
      ),
    ));
  }
}

class FloorPage extends StatelessWidget {
  var floor;
  var provider;
  var size;

  FloorPage({required this.floor, required this.provider, required this.size});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: provider.getRoomsList.length,
      itemBuilder: (context, index) {
        if (provider.getRoomsList[index].floor == floor &&
            provider.getRoomsList[index].bookingsServicesList != null) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteManagement.meetingRoom);
            },
            child: Card(
              child: Container(
                height: size.height * 0.09,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.getRoomsList[index].bookingsServicesList!
                            .where((element) => (DateTime.now()
                                    .isAfter(element.duration.start) &&
                                DateTime.now().isBefore(element.duration.end)))
                            .isNotEmpty)
                          Text('${provider.getRoomsList[index].roomName}'),
                        if (provider.getRoomsList[index].bookingsServicesList!
                            .where((element) => (DateTime.now()
                                    .isAfter(element.duration.start) &&
                                DateTime.now().isBefore(element.duration.end)))
                            .isNotEmpty)
                          Text(
                              'occupied by : ${provider.getRoomsList[index].bookingsServicesList!.where((element) => (DateTime.now().isAfter(element.duration.start) && DateTime.now().isBefore(element.duration.end))).first.user.username}'),
                        if (!provider.getRoomsList[index].bookingsServicesList!
                            .where((element) => (DateTime.now()
                                    .isAfter(element.duration.start) &&
                                DateTime.now().isBefore(element.duration.end)))
                            .isNotEmpty)
                          Text('${provider.getRoomsList[index].roomName}'),
                        if (!provider.getRoomsList[index].bookingsServicesList!
                            .where((element) => (DateTime.now()
                                    .isAfter(element.duration.start) &&
                                DateTime.now().isBefore(element.duration.end)))
                            .isNotEmpty)
                          Text('available'),
                      ],
                    ),
                    CircleAvatar(
                      maxRadius: 7,
                      backgroundColor: provider
                              .getRoomsList[index].bookingsServicesList!
                              .where((element) => (DateTime.now()
                                      .isAfter(element.duration.start) &&
                                  DateTime.now()
                                      .isBefore(element.duration.end)))
                              .isNotEmpty
                          ? Colors.red
                          : Colors.green,
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (provider.getRoomsList[index].floor == floor) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteManagement.meetingRoom);
            },
            child: Card(
              child: Container(
                height: size.height * 0.09,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${provider.getRoomsList[index].roomName}'),
                        Text('available'),
                      ],
                    ),
                    CircleAvatar(
                      maxRadius: 7,
                      backgroundColor: Colors.green,
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
