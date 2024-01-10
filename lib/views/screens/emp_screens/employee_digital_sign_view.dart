
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/models/events_model.dart';
import 'package:meals_management_with_firebase/providers/employee_home_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../custom_widgets/custom_button.dart';

// ignore: must_be_immutable
class DigitalSignView extends StatelessWidget{

  DateTime? data;

  SignatureController signatureController = SignatureController();

  DigitalSignView({super.key,this.data});

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 242, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 242, 250),
        title: const Text('Signature'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2),
                ),
                child: Signature(
                  controller: signatureController,
                  backgroundColor: Colors.white,
                  height: 350,
                  width: 350,
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(child: SizedBox(width: 180,)),
                  CustomButton(
                    onPressed: () => signatureController.clear(),
                    color: const MaterialStatePropertyAll(Colors.white),
                    child: const Text('Re-sign',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: CustomButton(
                      onPressed: () {
                        Provider.of<HomePageProvider>(context, listen: false).setOptions('opted');                      

                        if(signatureController.isNotEmpty){
                          Navigator.pushNamed(context, '/preview');
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('signature cannot be empty'))
                          );
                        }
                      },
                      color: MaterialStatePropertyAll(Colors.deepPurpleAccent.shade200),
                      child: const Text('Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}