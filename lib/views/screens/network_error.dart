import 'package:flutter/material.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';

class NetworkError extends StatefulWidget{

  @override
  State<NetworkError> createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError>{
  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/no_internet.png', fit: BoxFit.cover),
      ),
    );
  }
}