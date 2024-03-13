import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/meals_management/admin_employees_provider.dart';
import 'package:meals_management/views/in_app_tour.dart';
import 'package:meals_management/views/screens/meals_management/admin_screens/admin_employee_lunch_status_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class EmployeeSearch extends StatefulWidget {
  EmployeeSearch({super.key});

  @override
  State<EmployeeSearch> createState() => _EmployeeSearchState();
}

class _EmployeeSearchState extends State<EmployeeSearch>
    with ConnectivityMixin {
  SearchController employeeSearchController = SearchController();

  final FocusNode _focusNode = FocusNode();

  final sharedPreferences = sl.get<SharedPreferences>();

  final searchEmployeeKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void _initAddSiteInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets:
          addSearchEmployeeSiteTargets(searchEmployeeKey: searchEmployeeKey),
      colorShadow: Colors.black12,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      onFinish: () {
        print('employee home tutorial completed');
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        tutorialCoachMark.show(context: context);
        sharedPreferences.setBool('hasSeenTutorial5', true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
    if (!sharedPreferences.containsKey('hasSeenTutorial5')) {
      _initAddSiteInAppTour();
      _showInAppTour();
    }
  }

  @override
  void dispose() {
    employeeSearchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromRGBO(236, 230, 240, 100),
                  ),
                  child: Row(
                    key: searchEmployeeKey,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                      SizedBox(
                        width: size.width * 0.06,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: employeeSearchController,
                          onChanged: (searchText) {
                            if (searchText.length > 3) {
                              Provider.of<AdminEmployeesProvider>(context,
                                      listen: false)
                                  .getSearchData(searchText);
                            }
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search employee",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(
                                    73,
                                    69,
                                    79,
                                    100,
                                  ),
                                  fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Provider.of<AdminEmployeesProvider>(context, listen: true)
                          .alluserSearchList
                          .isNotEmpty &&
                      !Provider.of<AdminEmployeesProvider>(context,
                              listen: true)
                          .isSearching
                  ? Text(
                      isConnected() ? "Select Employee" : '',
                      style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100)),
                    )
                  : const Text(''),
              Consumer<AdminEmployeesProvider>(
                builder: (context, provider, child) {
                  print(isConnected());
                  print(provider.alluserSearchList.isEmpty);
                  return !isConnected()
                      ? Expanded(child: Text("No internet connection"))
                      : provider.isSearching &&
                              employeeSearchController.text.length >= 4 &&
                              isConnected()
                          ? Expanded(
                              child: CustomWidgets.CustomCircularLoader())
                          : provider.alluserSearchList.isEmpty
                              ? Expanded(
                                  child: Text(
                                      employeeSearchController.text.length > 3
                                          ? "No employee found"
                                          : ''))
                              : Expanded(
                                  child: Scrollbar(
                                    child: ListView(
                                      children: provider.alluserSearchList
                                          .map((item) => Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    bottom: 4.0),
                                                height: size.height * 0.1,
                                                child: Card(
                                                  elevation: 3,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      isConnected()
                                                          ? Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                transitionDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            200),
                                                                pageBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation) =>
                                                                    EmployeeLunchStatus(
                                                                  userName: item
                                                                      .userName,
                                                                  empID: item
                                                                      .empId,
                                                                ),
                                                                transitionsBuilder:
                                                                    (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                  const begin =
                                                                      Offset(1,
                                                                          0.0);
                                                                  const end =
                                                                      Offset
                                                                          .zero;
                                                                  final tween = Tween(
                                                                      begin:
                                                                          begin,
                                                                      end: end);
                                                                  final offsetAnimation =
                                                                      animation
                                                                          .drive(
                                                                              tween);
                                                                  return SlideTransition(
                                                                    position:
                                                                        offsetAnimation,
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : CustomWidgets
                                                              .CustomSnackBar(
                                                                  context,
                                                                  "No internet",
                                                                  Colors.red);
                                                    },
                                                    style: TextButton.styleFrom(
                                                        alignment: Alignment
                                                            .centerLeft),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.7,
                                                          child: Text(
                                                            (item as Data)
                                                                .empName
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: SizedBox()),
                                                        Text((item as Data)
                                                            .empId
                                                            .toString()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                );
                },
              ),
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Image.asset('assets/images/food.png')
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
