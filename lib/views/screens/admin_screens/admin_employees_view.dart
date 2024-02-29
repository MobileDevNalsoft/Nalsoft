import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/admin_employees_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class EmployeeSearch extends StatefulWidget {
  EmployeeSearch({super.key});

  @override
  State<EmployeeSearch> createState() => _EmployeeSearchState();
}

class _EmployeeSearchState extends State<EmployeeSearch>
    with ConnectivityMixin {
  SearchController employeeSearchController = SearchController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
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
        aspectRatio: size.height/size.width,
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
                      !Provider.of<AdminEmployeesProvider>(context, listen: true)
                          .isSearching
                  ?  Text(
                    isConnected()?
                      "Select Employee":'',
                      style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100)),
                    )
                  : const Text(''),
              Consumer<AdminEmployeesProvider>(
                builder: (context, provider, child) {
                  print(isConnected());
                  print(provider.alluserSearchList.isEmpty);
                  return !isConnected()?Expanded(child: Text("No internet connection")):
                  provider.isSearching &&
                              employeeSearchController.text.length >= 4 &&
                              isConnected()
                          ? Expanded(child: CustomWidgets.CustomCircularLoader())
                          :  provider.alluserSearchList.isEmpty?Expanded(child: Text(employeeSearchController.text.length>3?"No employee found":'')):Expanded(
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
                                                      ? Navigator.pushNamed(
                                                          context,
                                                          RouteManagement
                                                              .employeeLunchStatus,
                                                          arguments: {
                                                              'username':
                                                                  (item as Data)
                                                                      .userName
                                                                      .toString(),
                                                              'empid':
                                                                  (item as Data)
                                                                      .empId
                                                                      .toString()
                                                            })
                                                      : CustomSnackBar
                                                          .showSnackBar(
                                                              context,
                                                              "No internet",
                                                              Colors.red);
                                                },
                                                style: TextButton.styleFrom(
                                                    alignment:
                                                        Alignment.centerLeft),
                                                child: Row(
                                                  children: [
                                                    Text((item as Data)
                                                        .empName
                                                        .toString()),
                                                    Expanded(child: SizedBox()),
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
