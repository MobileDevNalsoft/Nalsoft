import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meals_management/providers/digital_signature_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

// ignore: must_be_immutable
class DigitalSignView extends StatelessWidget {
  DateTime? date;

  DigitalSignView({super.key, this.date});

  SignatureController signatureController = SignatureController();

  Widget build(BuildContext context) {
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
                ),
                child: Signature(
                  controller: signatureController,
                  backgroundColor: Colors.white,
                  height: 350,
                  width: 350,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: SizedBox(
                    width: 180,
                  )),
                  ElevatedButton(
                    child: Text(
                      'Re-sign',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => signatureController.clear(),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        elevation: MaterialStatePropertyAll(5)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Consumer<SignatureProvider>(
                        builder: (context, signatureProvider, child) {
                          return ElevatedButton(
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (signatureController.isNotEmpty) {
                                ui.Image? signatureImage =
                                    await signatureController.toImage();
                                ByteData? byteData =
                                    await signatureImage?.toByteData(
                                        format: ui.ImageByteFormat.png);
                                Uint8List pngBytes =
                                    byteData!.buffer.asUint8List();
                                    
                                await signatureProvider.uploadImage(pngBytes);
                                await signatureProvider.setSignatureUrl();
                                Provider.of<UserDataProvider>(context,
                                      listen: false)
                                  .setOptedDateWithURL(date: date!, url: signatureProvider.getURL);
                                var bytes =  pngBytes;
                                final file = await getTemporaryDirectory().then((dir) => File('${dir.path}/cached_image.jpg'));
                                await file.writeAsBytes(bytes);

                                Navigator.pushNamed(
                                    context, RouteManagement.previewPage);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.deepPurpleAccent.shade200),
                                elevation: MaterialStatePropertyAll(5)),
                          );
                        },
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
