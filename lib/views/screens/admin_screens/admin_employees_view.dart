import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/providers/admin_employees_provider.dart';
import 'package:meals_management_with_firebase/providers/universal_data_provider.dart';
import 'package:provider/provider.dart';

class Employees extends StatelessWidget {
  const Employees({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Provider.of<AdminEmployeesProvider>(context, listen: true)
            .getEmpList
            .isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(236, 230, 240, 100),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
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
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Department",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Text(':'),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          Provider.of<UniversalDataProvider>(context)
                              .getDDeptNameforEmployeesPage!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Select Employee",
                        style:
                            TextStyle(color: Color.fromRGBO(73, 69, 79, 100)),
                      ),
                    ],
                  ),
                  Consumer<AdminEmployeesProvider>(
                    builder: (context, provider, child) {
                      return Expanded(
                        child: Scrollbar(
                          child: ListView(
                            children: provider.getEmpList
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
                                            item['username'],
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
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate CSV")),
                  Image.asset("assets/images/food_png.png")
                ],
              ),
            ),
          );
  }
}
