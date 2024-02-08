
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../inits/di_container.dart';

// ignore: must_be_immutable
class Preview extends StatefulWidget {
  Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {

  final sharedPreferences = sl.get<SharedPreferences>();

  @override
  void initState() {
    super.initState();
  }

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 242, 250),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 247, 242, 250),
          toolbarHeight: 80,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(
                  context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              color: const Color.fromARGB(255, 247, 242, 250),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 50, top: 50),
                child: Card(
                  color: const Color.fromARGB(255, 234, 221, 255),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                              DateFormat.jm().format(now),
                              style: const TextStyle(fontSize: 25),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 247, 242, 250),
                        thickness: 2,
                      ),
                      QrImageView(
                        data:
                            '{"uid":"${sharedPreferences.getString('employee_id')}","date":"${DateTime.now().toString().substring(0, 10)}"}',//${DateTime.now().toString().substring(0, 10)}
                        size: 200,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Successfully Opted\n       for today',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(
                            Icons.task_alt_sharp,
                            color: Colors.green.shade800,
                            size: 40,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
