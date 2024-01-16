import 'package:flutter/material.dart';
import 'package:meals_management/providers/employee_search_provider.dart';
import 'package:meals_management/views/screens/route_management.dart';

import 'package:provider/provider.dart';

class EmployeeSearch extends StatefulWidget {
  EmployeeSearch({super.key});

  @override
  State<EmployeeSearch> createState() => _EmployeeSearchState();
}

class _EmployeeSearchState extends State<EmployeeSearch> {
  SearchController employeeSearchController = SearchController();

  final FocusNode _focusNode = FocusNode();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
    Future.delayed(
      Duration.zero,
      () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    try {
      await Provider.of<EmployeesSearchProvider>(context, listen: false)
          .setEmpList();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<dynamic> empList =
        Provider.of<EmployeesSearchProvider>(context).empList;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromRGBO(236, 230, 240, 100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.groups),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: employeeSearchController,
                        onChanged: (searchText) {
                          // if (searchText.length >= 3) {
                            Provider.of<EmployeesSearchProvider>(context,
                                    listen: false)
                                .isSearching=true;
                            Provider.of<EmployeesSearchProvider>(context,
                                    listen: false)
                                .setEmpList(search: searchText);
                          // }
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Provider.of<EmployeesSearchProvider>(context, listen: true)
                        .empList
                        .length !=
                    0 && !Provider.of<EmployeesSearchProvider>(context, listen: true)
                        .isSearching
                ? Text(
                    "Select Employee",
                    style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100)),
                  )
                : Text(''),
            Consumer<EmployeesSearchProvider>(
              builder: (context, provider, child) {
                return provider.empList.length == 0 &&
                        employeeSearchController.text != 0
                    ? Expanded(child: Text("No employee found"))
                    : provider.isSearching?CircularProgressIndicator():Expanded(
                        child: Scrollbar(
                          child: ListView(
                            children: provider.empList
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0, bottom: 4.0),
                                      height: size.height * 0.1,
                                      child: Card(
                                        elevation: 3,
                                        child: TextButton(
                                          onPressed: () {
                                            // Provider.of<EmployeeProvider>(context,listen:false).setUid();
                                            Navigator.pushNamed(
                                                context,
                                                RouteManagement
                                                    .employeeLunchStatus);
                                          },
                                          style: TextButton.styleFrom(
                                              alignment: Alignment.centerLeft),
                                          child: Text(
                                            item,
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
            MediaQuery.of(context).viewInsets.bottom == 0 ? Image.asset('assets/images/food.png') : SizedBox(),
          ],
        ),
      ),
    );
  }
}
