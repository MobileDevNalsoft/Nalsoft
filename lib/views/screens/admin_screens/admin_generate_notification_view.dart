import 'package:flutter/material.dart';
import 'package:meals_management/providers/admin_generate_notification_provider.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:meals_management/views/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

class GenerateNotification extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Color.fromARGB(100, 179, 110, 234),
      ),
      body: Column(
        children: [
          Text("Send notification"),
          Card(
            elevation: 1,
            margin: EdgeInsets.all(16),
            // width: size.width*0.95,
            // height: size.height*0.06,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //    border: Border.all(color: Colors.black)
            // ),
            child: TextField(
              controller: titleController,
                decoration: const InputDecoration(
              label: Text("Title"),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            )),
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: TextField(
               keyboardType: TextInputType.multiline,
               minLines: 1,
               maxLines: 10,
              controller: descriptionController,
                decoration: const InputDecoration(
              label: Text("Description"),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            )),
          ),
          SizedBox(
            width: size.width*0.3,
            child: CustomButton(
                child: Row(
                  children: [Icon(Icons.published_with_changes,color: Colors.white,),
                    Text(
                      "Publish",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                color: MaterialStatePropertyAll(Colors.blue),
                onPressed: (
                ) {
                  if (titleController.text.isEmpty){
                    CustomSnackBar.showSnackBar(context, "Title cannot be empty", Colors.red);  
                  }
                  else{
                    Provider.of<GenerateNotificationProvider>(context,listen:false).sendNotification(titleController.text,descriptionController.text);
                  }
                }),
          )
        ],
      ),
    );
  }
}
