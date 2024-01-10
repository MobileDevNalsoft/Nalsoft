import "package:flutter/material.dart";
import "package:meals_management_with_firebase/models/user_model.dart";
import "package:meals_management_with_firebase/providers/admin_home_provider.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../../providers/employee_home_provider.dart";
import "../../../services/firebase_auth_services.dart";

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late SharedPreferences sharedPreferences;

  ScrollController listViewController = ScrollController();

  UserModel? user;

  initiate() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HomePageProvider>(context, listen: false).setUserName();
    Provider.of<AdminHomeProvider>(context, listen: false).setDeptList();

    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Provider.of<AdminHomeProvider>(context, listen: true)
              .getDeptList
              .isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.13,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(100, 179, 110, 234),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, top: 15),
                          child: Text(
                            'Hi,\n${Provider.of<HomePageProvider>(context, listen: true).getUserName}',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Switch(
                          value: true,
                          onChanged: (value) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/emp_homepage', (route) => false);
                          },
                          activeColor: Color.fromARGB(255, 181, 129, 248),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                    child: Text('Sign Out'),
                                    value: 'Sign Out',
                                    height: 10,
                                    onTap: () {
                                      FirebaseAuthServices()
                                          .signOutNow()
                                          .then((value) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/login_page",
                                            (route) => false);
                                        sharedPreferences!
                                            .setString("islogged", 'false');
                                      });
                                    })
                              ];
                            },
                            child: Icon(Icons.power_settings_new_sharp),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromRGBO(236, 230, 240, 100),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {},
                          ),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search employee"),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text("Select Department",
                          style: TextStyle(
                              color: Color.fromRGBO(73, 69, 79, 100))),
                    ],
                  ),
                  Consumer<AdminHomeProvider>(
                    builder: (context, provider, child) {
                      return Expanded(
                        child: Scrollbar(
                          child: ListView(
                            controller: listViewController,
                            children: provider.deptList
                                .map((item) => Container(
                                      // color: Colors.amber,
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0, bottom: 4.0),

                                      height: size.height * 0.1,
                                      child: Card(
                                        elevation: 3,
                                        child: TextButton(
                                          onPressed: () {
                                            print(listViewController.position);
                                            Navigator.pushNamed(
                                                context, '/admin_employees');
                                          },
                                          style: TextButton.styleFrom(
                                              alignment: Alignment.centerLeft),
                                          child: Text(item),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/download_csv');
                      },
                      child: const Text("Generate CSV")),
                  Image.asset("assets/images/food_png.png")
                ],
              ),
            ),
    );
  }
}
