import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:meals_management_with_firebase/models/user_model.dart";
import "package:meals_management_with_firebase/providers/user_data_provider.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "../../../providers/employee_home_provider.dart";
import "../../../services/firebase_auth_services.dart";

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late SharedPreferences sharedPreferences;

  bool _isLoading = true;

  DateTime now = DateTime.now();

  @override
  initState() {
    super.initState();
    initiate();
    initData();
  }

  initiate() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> initData() async {
    try {
      await Provider.of<UserDataProvider>(context, listen: false).setUser();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    UserModel? user =
        Provider.of<UserDataProvider>(context, listen: false).getUser;

    return SafeArea(
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Consumer<EmployeeHomeProvider>(
                          builder: (context, provider, child) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 25, top: 15),
                              child: Text(
                                'Hi,\n${user!.userName}',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                        const Expanded(child: SizedBox()),
                        Consumer<EmployeeHomeProvider>(
                          builder: (context, provider, child) {
                            return user!.isAdmin
                                ? Switch(
                                    value: true,
                                    onChanged: (value) {
                                      Navigator.pushReplacementNamed(
                                          context, '/emp_homepage');
                                    },
                                    activeColor: const Color.fromARGB(
                                        255, 181, 129, 248),
                                  )
                                : const SizedBox();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                    value: 'Sign Out',
                                    height: 10,
                                    onTap: () => FirebaseAuthServices()
                                            .signOutNow()
                                            .then((value) {
                                          sharedPreferences!
                                              .setString("islogged", 'false');
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/login_page",
                                              (route) => false);
                                        }),
                                    child: const Text('Sign Out'))
                              ];
                            },
                            child: const Icon(Icons.power_settings_new_sharp),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(236, 230, 240, 100),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin_employees');
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.groups),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            const Expanded(
                                child: Text("Search employee",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(73, 69, 79, 100)))),
                            const Icon(Icons.search),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Text("Select Date",
                      style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100))),
                  SizedBox(
                    width: size.width * 0.95,
                    height: size.height * 0.5,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 4),
                            child: Text('Lunch Calendar'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 18),
                            child: Text(
                              '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                          const Divider(),
                          Consumer<EmployeeHomeProvider>(
                            builder: (context, provider, child) {
                              return Expanded(
                                child: SfDateRangePicker(
                                    showActionButtons: true,
                                    allowViewNavigation: true,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    showNavigationArrow: true,
                                    onSubmit: (date) {}),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Image.asset("assets/images/food_png.png")
                ],
              ),
            ),
    );
  }
}
