
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignPage extends StatelessWidget{

  SignatureController signatureController = SignatureController();

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 242, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 242, 250),
        title: Text('Signature'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Signature(
                  controller: signatureController,
                  backgroundColor: Colors.white,
                  height: 350,
                  width: 350,
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: SizedBox(width: 180,)),
                  ElevatedButton(
                    child: Text('Re-sign',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => signatureController.clear(),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        elevation: MaterialStatePropertyAll(5)
                    ),
                  ),
                  SizedBox(width: 15,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ElevatedButton(
                      child: Text('Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if(signatureController.isNotEmpty){
                          Navigator.pushNamed(context, '/preview');
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.deepPurpleAccent.shade200),
                          elevation: MaterialStatePropertyAll(5)
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