import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/meals_management/firebase_provider.dart';
import 'package:meals_management/repositories/firebase_repo.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:provider/provider.dart';

class GenerateNotification extends StatefulWidget {
  const GenerateNotification({super.key});

  @override
  State<GenerateNotification> createState() => _GenerateNotificationState();
}

class _GenerateNotificationState extends State<GenerateNotification>
    with ConnectivityMixin {
  
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getToken();
  }


  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
            title: const Text("Send Notification",style: TextStyle(fontSize: 18)),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            backgroundColor: const Color.fromARGB(100, 179, 110, 234),
          ),
          body: Stack(children: [
            Column(
              children: [
                Card(
                  elevation: 1,
                  margin: const EdgeInsets.all(16),
                  child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        label: Text("Title"),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      )),
                ),
                Card(
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                  child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 10,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        label: Text("Description"),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                      )),
                ),
                SizedBox(
                  width: size.width * 0.35,
                  child: CustomWidgets.CustomElevatedButton(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade300),
                      onPressed: () async {
                        if (isConnected()) {
                          FocusScope.of(context).requestFocus(focusNode);
                          if (titleController.text.isEmpty) {
                            CustomWidgets.CustomSnackBar(
                                context, "Title cannot be empty", Colors.red);
                          } else if (descriptionController.text.isEmpty) {
                            CustomWidgets.CustomSnackBar(context,
                                "Description cannot be empty", Colors.red);
                          } else {
                            bool result = await Provider.of<FirebaseProvider>(
                                    context,
                                    listen: false)
                                .sendNotification(titleController.text,
                                    descriptionController.text);
                            if (result) {
                              CustomWidgets.CustomSnackBar(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  "Successfully sent",
                                  Colors.green);
                              titleController.clear();
                              descriptionController.clear();
                            } else {
                              // ignore: use_build_context_synchronously
                              CustomWidgets.CustomSnackBar(context,
                                  "Could not send notification", Colors.red);
                            }
                          }
                        } else {
                          CustomWidgets.CustomSnackBar(
                              context, "No internet connection", Colors.red);
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.published_with_changes,
                            color: Colors.black,
                          ),
                          Text(
                            " Publish",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )),
                )
              ],
            ),
            if (Provider.of<FirebaseProvider>(context, listen: true).isLoading)
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
