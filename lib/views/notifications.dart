import 'package:flutter/material.dart';
import 'package:meals_management/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class UpcomingMeetingsView extends StatefulWidget {
  @override
  State<UpcomingMeetingsView> createState() => _UpcomingMeetingsView();
}

class _UpcomingMeetingsView extends State<UpcomingMeetingsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Upcoming Meetings'),
            backgroundColor: Colors.blueGrey.shade400,
          ),
          backgroundColor: Colors.blueGrey.shade100,
          body: Padding(
            padding: EdgeInsets.only(top: 10, left: 9),
            child: SizedBox(
              height: size.height,
              width: size.width * 0.95,
              child: Consumer<FirebaseProvider>(
                  builder: (context, provider, child) {
                    print("consumer ${provider.notifications}");
                return ListView.builder(
                  itemCount: provider.notifications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        height: size.height * 0.125,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
