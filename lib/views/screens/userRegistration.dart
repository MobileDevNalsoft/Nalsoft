import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:mess_management/providers/userProvider.dart';
import 'package:mess_management/services/auth/user_authentication.dart';
import 'package:mess_management/utils/constants.dart';
import 'package:mess_management/views/screens/route_management.dart';
import 'package:mess_management/views/widgets/resuableWidgets.dart';
import 'package:provider/provider.dart';
// import 'login_view.dart';

class UserRegistrationView extends StatefulWidget {
  @override
  State<UserRegistrationView> createState() => _UserRegistrationViewState();
}

class _UserRegistrationViewState extends State<UserRegistrationView> {
  Widgets reusableWidgets = Widgets();
  FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _empIdController = TextEditingController();

  final _deptController = TextEditingController();

  final _floorController = TextEditingController();

  final _createPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              reusableWidgets.fieldElevation(
                                child: reusableWidgets.textFormField(
                                    cont: _emailController,
                                    hntTxt: '  username or email'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              reusableWidgets.fieldElevation(
                                child: reusableWidgets.textFormField(
                                    cont: _empIdController,
                                    hntTxt: '  employee id'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              reusableWidgets.fieldElevation(
                                child: reusableWidgets.textFormField(
                                    cont: _deptController,
                                    hntTxt: '  department'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              reusableWidgets.fieldElevation(
                                child: reusableWidgets.textFormField(
                                    cont: _floorController, hntTxt: '  floor'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              reusableWidgets.fieldElevation(
                                child: reusableWidgets.textFormField(
                                    cont: _createPasswordController,
                                    hntTxt: '  create password'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              reusableWidgets.fieldElevation(
                                child: reusableWidgets.textFormField(
                                    cont: _confirmPasswordController,
                                    hntTxt: '  confirm password'),
                              ),
                            ],
                          )),
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MediaQuery.of(context).viewInsets.bottom == 0
                ? ElevatedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.black,
                                    ))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade300)),
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('email cannot be empty')));
                      } else if (_emailController.text.length < 5 &&
                          !_emailController.text.contains('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('email must contain @')));
                      } else if (_empIdController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('employee id cannot be empty')));                            
                      } 
                      else if (_deptController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('department cannot be empty')));
                      } 
                      else if (_createPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('password cannot be empty')));
                      } else if (_createPasswordController.text.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'password must be atleast 10 characters')));
                      } else if (!Constants.regex
                          .hasMatch(_createPasswordController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'password must include atleast one special symbol, lowercase and uppercase letter')));
                      } else if (_createPasswordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('passwords must match')));
                      } else {
                        _signUp(context);
                      }
                    },
                  )
                : SizedBox(),
            MediaQuery.of(context).viewInsets.bottom == 0
                ? Image.asset('assets/images/food.png')
                : SizedBox(),
          ],
        ));
  }

  void _signUp(context) async {
    String email = _emailController.text.trim();
    String password = _createPasswordController.text.trim();
    print("${email}${password}");
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    print(user);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have successfully registered')));
      final user = UserModel(
          email, password, _deptController.text, _floorController.text);

      // _db.createUser(user);
      Navigator.pushNamed(context, RouteManagement.homePage);
    }
  }
}
