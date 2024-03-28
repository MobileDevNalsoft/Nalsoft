import 'dart:io';
import 'dart:typed_data';

import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class GenerateQr extends StatefulWidget {
  const GenerateQr({super.key});

  @override
  State<GenerateQr> createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  bool isQrGenerated = false;
  TextEditingController qrNameController = TextEditingController();
  GlobalKey qrImageKey = GlobalKey();
  // WidgetsToImageController to access widget
  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FocusNode focusNode = FocusNode();

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Generate QR", style: TextStyle(fontSize: 18)),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            backgroundColor: const Color.fromARGB(100, 179, 110, 234),
          ),
          body: Column(
            children: [
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: qrNameController,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isQrGenerated = false;
                    });
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.35,
                child: CustomWidgets.CustomElevatedButton(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.grey.shade300),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(focusNode);
                      qrNameController.text.isEmpty
                          ? CustomWidgets.CustomSnackBar(
                              context, "Please enter the name", Colors.red)
                          : setState(() {
                              isQrGenerated = true;
                            });
                    },
                    child: const Text(
                      "Generate",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              isQrGenerated && qrNameController.text.isNotEmpty
                  ? WidgetsToImage(
                      key: qrImageKey,
                      controller: widgetsToImageController,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: QrImageView(
                          data:
                              '{"uid":"${qrNameController.text}","date":"${DateTime.now().toString().substring(0, 10)}"}', //${DateTime.now().toString().substring(0, 10)}
                          size: 250,
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: size.height * 0.035),
              if (isQrGenerated && qrNameController.text.isNotEmpty)
                IconButton(
                    onPressed: () async {
                      final bytes = await widgetsToImageController.capture();
                      final dir = await getTemporaryDirectory();
                      final path =
                          '${dir.path}/QrCodes${qrNameController.text}.png';
                      final File file = File(path);
                      await file.writeAsBytes(bytes as List<int>);

                      await Share.shareXFiles(
                        [XFile(path)],
                        text:
                            '${qrNameController.text}_${DateTime.now().toString().substring(0, 10)}_QR',
                      );
                    },
                    icon: const Icon(
                      Icons.share_rounded,
                      size: 40,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
