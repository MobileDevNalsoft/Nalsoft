import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/providers/meals_management/user_data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NotificationsView extends StatelessWidget {
  Stream<DocumentSnapshot>? stream;
  NotificationsView({super.key, this.stream});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Notifications'),
            backgroundColor: const Color.fromARGB(100, 179, 110, 234),
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
          ),
          body: Center(
            child: SizedBox(
              height: size.height,
              width: size.width * 0.95,
              child: Consumer<UserDataProvider>(
                builder: (context, provider, child) {
                  return provider.notifications == null ||
                          provider.notifications!.isEmpty
                      ? const Center(
                          child: Text(
                            'No Notifications',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.notifications!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromRGBO(236, 230, 240, 100),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.notifications![index]
                                              ['title'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          provider.notifications![index]
                                              ['description'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    if (provider.notifications![index]
                                            ['time'] !=
                                        null)
                                      Text(DateTime.fromMillisecondsSinceEpoch(
                                              provider.notifications![index]
                                                  ['time'])
                                          .toString()
                                          .substring(11, 16))
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
