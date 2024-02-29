import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:meals_management/views/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ConnectivityMixin {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthenticationProvider>(
                                              context,
                                              listen: false)
                                          .getToken();
  }
  final GlobalKey _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

      @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [Container(
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
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomElevatedButton(
                                      onPressed: () {
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        if (_emailController.text.isEmpty) {
                                          CustomSnackBar.showSnackBar(
                                              context,
                                              'Email cannot be empty',
                                              Colors.red);
                                        } else if (!_emailController.text
                                            .contains('@nalsoft.net')) {
                                          CustomSnackBar.showSnackBar(
                                              context,
                                              'Email must contain @nalsoft.net',
                                              Colors.red);
                                        } else if (_passwordController
                                            .text.isEmpty) {
                                          CustomSnackBar.showSnackBar(
                                              context,
                                              'Password cannot be empty',
                                              Colors.red);
                                        } else {
                                          if (isConnected()) {
                                            Provider.of<AuthenticationProvider>(
                                              context,
                                              listen: false).loginLoader=true;
                                            Provider.of<AuthenticationProvider>(
                                              context,
                                              listen: false)
                                          .getToken()
                                          .then((value) =>
                                              Provider.of<AuthenticationProvider>(
                                                      context,
                                                      listen: false)
                                                  .authenticateUserName(
                                                      _emailController.text,
                                                      _passwordController.text,
                                                      context));
                                          } else {
                                            CustomWidgets.CustomSnackBar(context,
                                                'No Internet', Colors.red);
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
             if (Provider.of<AuthenticationProvider>(context, listen: true)
                  .loginLoader)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      color: Colors.black38,
                      child: CustomWidgets.CustomCircularLoader()),
                ),
            ]),
        ),
      ),
    );
  }
}
