import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/admin_generate_notification_provider.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class GenerateNotification extends StatefulWidget {
  @override
  State<GenerateNotification> createState() => _GenerateNotificationState();
}

class _GenerateNotificationState extends State<GenerateNotification>
    with ConnectivityMixin {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose(){
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
        aspectRatio: size.height/size.width,
        child: Scaffold(
          
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: Text("Send notification"),centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            backgroundColor: const Color.fromARGB(100, 179, 110, 234),
          ),
          body: Stack(
            children: [Column(
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
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
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
                  child: CustomElevatedButton(
                          color: MaterialStatePropertyAll(
                                            Colors.grey.shade300),
                          onPressed: () async {
                            if (isConnected()) {
                              FocusScope.of(context).requestFocus(focusNode);
                              if (titleController.text.isEmpty) {
                                CustomSnackBar.showSnackBar(
                                    context, "Title cannot be empty", Colors.red);
                              } else {
                                bool result =
                                    await Provider.of<GenerateNotificationProvider>(
                                            context,
                                            listen: false)
                                        .sendNotification(titleController.text,
                                            descriptionController.text);
                                if (result) {
                                  CustomSnackBar.showSnackBar(
                                      context, "Successfully sent", Colors.green);
                                      titleController.clear();
                                      descriptionController.clear();
                                } else {
                                  CustomSnackBar.showSnackBar(context,
                                      "Could not send notification", Colors.red);
                                }
                              }
                            } else
                              CustomSnackBar.showSnackBar(
                                  context, "No internet connection", Colors.red);
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
            if(Provider.of<GenerateNotificationProvider>(context,
                            listen: true)
                        .isLoading) Positioned(
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
