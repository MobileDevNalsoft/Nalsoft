import 'package:flutter/material.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:meals_management/views/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  SharedPreferences? sharedPreferences;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initiate();
  }

  initiate() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white, // background color of Container
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // adjusts width and height according to device dimensions
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 3,
              child: Image.asset('assets/images/login_page_img.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 60.0, left: 70),
              child: Image.asset('assets/images/nalsoft_logo.png'),
            ),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextFormField(
                            hintText: 'email',
                            controller: _emailController,
                            prefixIcon: const Icon(Icons.person),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Consumer<AuthenticationProvider>(
                              builder: (context, provider, _) {
                            return CustomTextFormField(
                              hintText: 'password',
                              controller: _passwordController,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextButton(
                                onPressed: null,
                                child: Text(
                                  'forgot password?',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RouteManagement.signUp);
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                onPressed: () async {
                                  if (_emailController.text.isEmpty) {
                                    CustomSnackBar.showSnackBar(
                                        context, 'email cannot be empty');
                                  } else if (!_emailController.text
                                      .contains('@nalsoft.net')) {
                                    CustomSnackBar.showSnackBar(context,
                                        'email must contain @nalsoft.net');
                                  } else if (_passwordController.text.isEmpty) {
                                    CustomSnackBar.showSnackBar(
                                        context, 'password cannot be empty');
                                  } else if (_passwordController.text.length <
                                      10) {
                                    CustomSnackBar.showSnackBar(context,
                                        'password must be atleast 10 characters');
                                  } else if (!Constants.regex
                                      .hasMatch(_passwordController.text)) {
                                    CustomSnackBar.showSnackBar(context,
                                        'password must include atleast one special symbol, lowercase and uppercase letter');
                                  } else {
                                    var isSuccess =
                                        await Provider.of<UserDataProvider>(
                                                context,
                                                listen: false)
                                            .userLogin(
                                                _emailController.text.trim(),
                                                _passwordController.text
                                                    .trim());
                                    if (isSuccess) {
                                      sharedPreferences!
                                          .setString("islogged", "true");
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteManagement.employeeHomePage,
                                          (route) => false);
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Login Successful')));
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Some error has occurred')));
                                    }
                                  }
                                },
                                color: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/images/food.png',
                fit: BoxFit.fill, // Fill the width of the screen
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
