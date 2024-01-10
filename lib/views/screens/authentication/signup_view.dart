import "package:flutter/material.dart";
import 'package:meals_management_with_firebase/providers/signup_provider.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';
import 'package:meals_management_with_firebase/utils/constants.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_dropdown.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/login_provider.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_snackbar.dart';

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  final DatabaseServices _db = DatabaseServices();

  late SharedPreferences sharedPreferences;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _empIdController = TextEditingController();
  final _createPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  initState() {
    super.initState();
    initiate();
  }

  initiate() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Provider.of<SignupProvider>(context, listen: false).setDeptandFloorList();

    return Provider.of<SignupProvider>(context, listen: true)
            .getDeptList
            .isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset('assets/images/food_png.png'),
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
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    controller: _usernameController,
                                    hintText: 'username',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  CustomTextFormField(
                                    controller: _emailController,
                                    hintText: 'email',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  CustomTextFormField(
                                    controller: _empIdController,
                                    hintText: 'employee id',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.018,
                                  ),
                                  Consumer<LoginProvider>(
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
                                  Consumer<LoginProvider>(
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
                                      Consumer<SignupProvider>(
                                        builder: (context, provider, child) {
                                          return Expanded(
                                            child: CustomDropDown(
                                              hint: Text(
                                                'Department',
                                              ),
                                              value: provider.getDept,
                                              items: provider.getDeptList
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (value) => DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? newValue) {
                                                provider.setDept(newValue!);
                                              },
                                              menuMaxHeight: size.height * 0.5,
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      Consumer<SignupProvider>(
                                        builder: (context, provider, child) {
                                          return CustomDropDown(
                                            hint: Text(
                                              'Floor',
                                            ),
                                            value: provider.getFloor,
                                            items: provider.getFloorList
                                                .map<DropdownMenuItem<String>>(
                                                  (value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    alignment: Alignment.center,
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (String? newValue) {
                                              provider.setFloor(newValue!);
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
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
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
                          } else if (Provider.of<SignupProvider>(context,
                                          listen: false)
                                      .getDept ==
                                  null ||
                              Provider.of<SignupProvider>(context,
                                          listen: false)
                                      .getFloor ==
                                  null) {
                            CustomSnackBar.showSnackBar(context,
                                'please select your department and floor');
                          } else {
                            var isSuccess = await Provider.of<SignupProvider>(
                                    context,
                                    listen: false)
                                .signUp(
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
                              Navigator.pushNamed(context, '/emp_homepage');
                            } else {
                              print('some error occurred');
                            }
                          }
                        },
                        color: MaterialStatePropertyAll(Colors.grey.shade300),
                      )
                    : const SizedBox(),
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? Image.asset('assets/images/food_png.png')
                    : const SizedBox(),
              ],
            ));
  }
}
