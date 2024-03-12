import 'package:flutter/material.dart';
import 'package:meals_management/models/meeting_rooms_management/user_model.dart';
import 'package:meals_management/providers/meeting_rooms_management/home_view_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/custom_widgets/expanded_fab.dart';
import 'package:provider/provider.dart';
import 'package:custom_widgets/src.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  final PageController _pageController = PageController();
  final PageController _floorPageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HomeViewProvider>(context, listen: false).setUser =
        MRUserModel(username: 'Madhan', userID: '00633', myBookings: [
      SpecificMeetingRoomModel(
          roomName: 'Meeting Room 1',
          floor: 8,
          size: 4,
          duration: DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(Duration(hours: 1)))),
      SpecificMeetingRoomModel(
          roomName: 'Meeting Room 5',
          floor: 8,
          size: 8,
          duration: DateTimeRange(
              start: DateTime.now().add(Duration(minutes: 1)),
              end: DateTime.now().add(Duration(hours: 2)))),
      SpecificMeetingRoomModel(
          roomName: 'Meeting Room 1',
          floor: 1,
          size: 5,
          duration: DateTimeRange(
              start: DateTime.now().add(Duration(minutes: 2)),
              end: DateTime.now().add(Duration(hours: 3)))),
      SpecificMeetingRoomModel(
          roomName: 'Meeting Room 3',
          floor: 1,
          size: 8,
          duration: DateTimeRange(
              start: DateTime.now().add(Duration(minutes: 3)),
              end: DateTime.now().add(Duration(hours: 1)))),
      SpecificMeetingRoomModel(
          roomName: 'Meeting Room 3',
          floor: 9,
          size: 8,
          duration: DateTimeRange(
              start: DateTime.now().add(Duration(minutes: 4)),
              end: DateTime.now().add(Duration(hours: 1)))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Dashboard'),
              centerTitle: true,
              backgroundColor: Colors.blueGrey.shade400,
            ),
            backgroundColor: Colors.blueGrey.shade100,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Consumer<HomeViewProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        if (provider.getUser.myBookings!.isNotEmpty)
                          Text('Upcoming Meetings'),
                        if (provider.getUser.myBookings!.isNotEmpty)
                          SizedBox(
                            height: size.height * 0.1,
                            width: size.width * 0.9,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                provider.setCurrentPage = page;
                              },
                              children: [
                                provider.getUser.myBookings!
                                  ..sort((a, b) => a.duration.start
                                      .compareTo(b.duration.start))
                              ][0]
                                  .take(5)
                                  .map((e) => Card(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    DateFormat(
                                                            'EEEE, MMM dd yyyy')
                                                        .format(
                                                            e.duration.start),
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  Text(
                                                      '${DateFormat.Hm().format(e.duration.start)} to ${DateFormat.Hm().format(e.duration.end)}',
                                                      style: TextStyle(
                                                          fontSize: 13))
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('${e.roomName}',
                                                      style: TextStyle(
                                                          fontSize: 13)),
                                                  Text('Floor ${e.floor}',
                                                      style: TextStyle(
                                                          fontSize: 13))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        if (provider.getUser.myBookings!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                provider.getUser.myBookings!.length > 5
                                    ? 5
                                    : provider.getUser.myBookings!.length,
                                (index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor:
                                      index == provider.getCurrentPage
                                          ? Colors.blueGrey
                                          : Colors.white,
                                  maxRadius: 4,
                                ),
                              );
                            }),
                          ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
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
                                        child:
                                            CustomWidgets.CustomElevatedButton(
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
                                          backgroundColor:
                                              MaterialStateProperty.all(provider
                                                          .getCurrentFloorPage ==
                                                      e.keys.first
                                                  ? Colors.blueGrey.shade500
                                                  : Colors.blueGrey.shade200),
                                          child: Text(
                                            'Floor ${e.values.first}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    provider.getCurrentFloorPage ==
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
                            height: size.height * 0.6,
                            width: size.width * 0.9,
                            child: PageView(
                              controller: _floorPageController,
                              onPageChanged: (int page) {
                                provider.setCurrentFloorPage = page;
                              },
                              children: [1, 8, 9]
                                  .map((e) => FloorPage(
                                      floor: e, provider: provider, size: size))
                                  .toList(),
                            ))
                      ],
                    );
                  },
                )
              ],
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(right: 15, bottom: 30),
              child: ExpandableFAB(
                distance: 55,
                children: [
                  ActionButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteManagement.upcomingMeetingsView);
                    },
                    icon: Icon(
                      Icons.event_sharp,
                      color: Colors.white60,
                    ),
                  ),
                  ActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            RouteManagement.checkavalabilityStatusView);

                        Provider.of<HomeViewProvider>(context, listen: false)
                            .setCheckAvailabilityCurrentFloorPage = 0;
                      },
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.white60,
                      ))
                ],
              ),
            )),
      ),
    );
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
