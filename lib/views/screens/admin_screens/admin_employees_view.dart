import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/providers/admin_employees_provider.dart';
import 'package:provider/provider.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {

  final FocusNode _focusNode = FocusNode();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
    Future.delayed(Duration.zero,() {
      FocusScope.of(context).requestFocus(_focusNode);
    },);
  }

  @override
  void dispose(){
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> initData() async{
    try{
      await Provider.of<AdminEmployeesProvider>(context, listen: false).setEmpList();
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    List<dynamic> empList = Provider.of<AdminEmployeesProvider>(context).empList;

    return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15,),
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
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search employee",
                                  hintStyle: TextStyle(color: Color.fromRGBO(73, 69, 79, 100,), fontSize: 14)
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              
                            },
                            icon: const Icon(Icons.search),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  const Text(
                    "Select Employee",
                    style:
                        TextStyle(color: Color.fromRGBO(73, 69, 79, 100)),
                  ),
                  Consumer<AdminEmployeesProvider>(
                    builder: (context, provider, child) {
                      return Expanded(
                        child: Scrollbar(
                          child: ListView(
                            children: empList
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0, bottom: 4.0),
                                      height: size.height * 0.1,
                                      child: Card(
                                        elevation: 3,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                '/employee_lunch_status');
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
                  Image.asset("assets/images/food_png.png")
                ],
              ),
            ),
          );
  }
}
