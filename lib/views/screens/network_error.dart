import 'package:flutter/material.dart';
import 'package:meals_management/mixin/network_handler.dart';

class NetworkError extends StatefulWidget{

  @override
  State<NetworkError> createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> with ConnectivityMixin{
  @override
  Widget build(BuildContext context){
    if(isConnected()){
      Navigator.pop(context);
    }
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/no_internet.png'),
      ),
    );
  }
}