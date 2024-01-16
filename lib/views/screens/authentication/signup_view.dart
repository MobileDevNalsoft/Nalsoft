import "package:flutter/material.dart";
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/custom_widgets/custom_dropdown.dart';
import 'package:meals_management/views/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_snackbar.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey formKey = GlobalKey<FormState>();

  late SharedPreferences sharedPreferences;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _empIdController = TextEditingController();
  final _createPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = true;

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
      await Provider.of<AuthenticationProvider>(context, listen: false)
          .setDeptandFloorList();
    } finally {
      // Set loading state to false when data fetching is complete
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset('assets/images/food.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset('assets/images/nalsoft_logo.png'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: size.width,
                      child: Column(children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    controller: _usernameController,
                                    hintText: 'username',
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  CustomTextFormField(
                                    controller: _emailController,
                                    hintText: 'email',
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  CustomTextFormField(
                                    controller: _empIdController,
                                    hintText: 'employee id',
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  Consumer<AuthenticationProvider>(
                                      builder: (context, provider, _) {
                                    return CustomTextFormField(
                                      hintText: 'create password',
                                      controller: _createPasswordController,
                                      prefixIcon: const Icon(Icons.lock),
                                      obscureText: provider.obscurePassword,
                                      obscureChar: '*',
                                      suffixIcon: IconButton(
                                        iconSize: 20,
                                        onPressed: () => {
                                          provider.obscureToggle(),
                                        },
                                        icon: provider.obscurePassword
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  Consumer<AuthenticationProvider>(
                                      builder: (context, provider, _) {
                                    return CustomTextFormField(
                                      hintText: 'confirm password',
                                      controller: _confirmPasswordController,
                                      prefixIcon: const Icon(Icons.lock),
                                      obscureText: provider.obscurePassword,
                                      obscureChar: '*',
                                      suffixIcon: IconButton(
                                        iconSize: 20,
                                        onPressed: () => {
                                          provider.obscureToggle(),
                                        },
                                        icon: provider.obscurePassword
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  Row(
                                    children: [
                                      Consumer<AuthenticationProvider>(
                                        builder: (context, provider, child) {
                                          return Expanded(
                                            child: CustomDropDown(
                                              hint: const Text(
                                                'Department',
                                              ),
                                              value:
                                                  Provider.of<UserDataProvider>(
                                                          context)
                                                      .getDept,
                                              items: provider.getDeptList
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (value) => DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? newValue) {
                                                Provider.of<UserDataProvider>(
                                                        context,
                                                        listen: false)
                                                    .setDept(newValue!);
                                              },
                                              menuMaxHeight: size.height * 0.5,
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      Consumer<AuthenticationProvider>(
                                        builder: (context, provider, child) {
                                          return CustomDropDown(
                                            hint: const Text(
                                              'Floor',
                                            ),
                                            value:
                                                Provider.of<UserDataProvider>(
                                                        context)
                                                    .getFloor,
                                            items: provider.getFloorList
                                                .map<DropdownMenuItem<String>>(
                                                  (value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (String? newValue) {
                                              Provider.of<UserDataProvider>(
                                                      context,
                                                      listen: false)
                                                  .setFloor(newValue!);
                                            },
                                            menuMaxHeight: size.height * 0.5,
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? CustomButton(
                        onPressed: () async {
                          if (_usernameController.text.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                context, 'username cannot be empty');
                          } else if (_usernameController.text.length > 20) {
                            CustomSnackBar.showSnackBar(context,
                                'username cannot have greater than 20 characters');
                          } else if (_emailController.text.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                context, 'email cannot be empty');
                          } else if (!_emailController.text
                              .contains('@nalsoft.net')) {
                            CustomSnackBar.showSnackBar(
                                context, 'email must contain @nalsoft.net');
                          } else if (_empIdController.text.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                context, 'employee id cannot be empty');
                          } else if (!Constants.empIDRegex
                                  .hasMatch(_empIdController.text) ||
                              _empIdController.text.length != 5 ||
                              _empIdController.text.isEmpty) {
                            CustomSnackBar.showSnackBar(context,
                                'please enter your 5 digit employee id');
                          } else if (_confirmPasswordController.text.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                context, 'password cannot be empty');
                          } else if (_confirmPasswordController.text.length <
                              10) {
                            CustomSnackBar.showSnackBar(context,
                                'password must be atleast 10 characters');
                          } else if (!Constants.regex
                              .hasMatch(_confirmPasswordController.text)) {
                            CustomSnackBar.showSnackBar(context,
                                'password must include atleast one special symbol, lowercase and uppercase letter');
                          } else if (_createPasswordController.text !=
                              _confirmPasswordController.text) {
                            CustomSnackBar.showSnackBar(
                                context, 'passwords must match');
                          } else if (Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .getDept ==
                                  null ||
                              Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .getFloor ==
                                  null) {
                            CustomSnackBar.showSnackBar(context,
                                'please select your department and floor');
                          } else {
                            var isSuccess = await Provider.of<UserDataProvider>(
                                    context,
                                    listen: false)
                                .createUser(
                                    _usernameController.text,
                                    _emailController.text.trim(),
                                    _empIdController.text.trim(),
                                    _confirmPasswordController.text);
                            if (isSuccess) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You have successfully registered')));
                              // ignore: use_build_context_synchronously
                              sharedPreferences.setString('islogged', 'true');
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(
                                  context, RouteManagement.employeeHomePage);
                            } else {
                              print('some error occurred');
                            }
                          }
                        },
                        color: MaterialStatePropertyAll(Colors.grey.shade300),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : const SizedBox(),
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? Image.asset('assets/images/food.png')
                    : const SizedBox(),
              ],
            ),
    );
  }
}
