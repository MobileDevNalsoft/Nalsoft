
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess_management/providers/emp_home_provider.dart';
import 'package:mess_management/views/screens/route_management.dart';
import 'package:mess_management/views/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserHomePage extends StatelessWidget{

  DateTime now = DateTime.now();

  TextEditingController notOptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.22,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(100, 179, 110, 234),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, top: 15),
                          child: Text('Hi,\n${Provider.of<HomePageProvider>(context, listen: false).getUserName}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25, top: 25),
                          child: Icon(Icons.account_circle_sharp,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 4),
                            child: Text('Lunch Calendar'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 18),
                            child: Text(
                              '${DateFormat('EEEE').format(now).substring(
                                  0, 3)}, ${DateFormat('MMMM')
                                  .format(now)
                                  .substring(0, 3)} ${now.day}',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Divider(),
                           Consumer<HomePageProvider>(
                            builder: (context, provider, child) {
                              return SfDateRangePicker(
                                showActionButtons: true,
                                allowViewNavigation: false,
                                selectionMode: DateRangePickerSelectionMode.single,
                                showNavigationArrow: true,
                                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                                  showDialog(context: context, builder: (context) {
                                   return AlertDialog(content: Text("opt for lunch"),actions: [TextButton(onPressed: (){},child: Text("cancel"),)],);
                                  },);
                                  
                                },
                                onSubmit: (date) {
                                  if(date == null || date.toString().substring(0,10) != now.toString().substring(0,10)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('please select today''s date'))
                                    );
                                  }
                                  else{
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            content: Consumer<HomePageProvider>(
                                              builder: (context, value, child) {
                                                return SizedBox(
                                                  width: size.width * 0.6,
                                                  height: provider.getRadioValue == 2 ? size.height * 0.365 : size.height * 0.22,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      _radioButtons(provider: provider, text: 'Opt and Sign', value: 1),
                                                      _radioButtons(provider: provider, text: 'Not opt', value: 2),
                                                      if(provider.getRadioValue == 2)
                                                        TextFormField(
                                                          controller: notOptController,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              hintText: 'reason for not opting...',
                                                              hintStyle: TextStyle(color: Colors.black38),
                                                              errorText: provider.getReasonEmpty ? 'reason cannot be empty' : null
                                                          ),
                                                          maxLines: 2,
                                                          maxLength: 30,
                                                          onChanged: (value) {
                                                            if(value.isEmpty){
                                                              provider.setReasonEmpty(true);
                                                            }
                                                            else{
                                                              provider.setReasonEmpty(false);
                                                            }
                                                          },
                                                        ),
                                                      const SizedBox(height: 12,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .end,
                                                        children: [
                                                          CustomButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors.black),
                                                            ),
                                                            color: const MaterialStatePropertyAll(Colors.white),
                                                          ),
                                                          const SizedBox(width: 5,),
                                                          CustomButton(
                                                            onPressed: () {
                                                              provider.setOptions('not opted');

                                                              if (provider.getRadioValue == 1) {
                                                                Navigator.pop(context);
                                                                Navigator.pushNamed(context, '/sign');
                                                              }
                                                              else if(notOptController.text.isEmpty){
                                                                provider.setReasonEmpty(true);
                                                              }
                                                              else{
                                                                Navigator.pop(context);
                                                              }
                                                            },
                                                            child: const Text(
                                                              'Proceed',
                                                              style: TextStyle(color: Colors.white),),
                                                            color: MaterialStatePropertyAll(Colors.deepPurpleAccent.shade200),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  // Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _options(color: Colors.green.shade200, text: Text('Signed', style: TextStyle(fontSize: 13),)),
                        _options(color: Colors.grey.shade300, text: Text('Not Signed', style: TextStyle(fontSize: 13),)),
                        _options(color: Colors.orange.shade200, text: Text('Not Opted', style: TextStyle(fontSize: 13),)),
                        _options(color: Colors.red.shade100, text: Text('Holiday', style: TextStyle(fontSize: 13),)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.1,
                    child: Image.asset(
                      'assets/images/food.png',
                      fit: BoxFit.fill, // Fill the width of the screen
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -450,
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    SizedBox(width: 40,),
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.12,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time_sharp),
                                  SizedBox(width: 5),
                                  Text('Lunch Timings')
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text('Start time:',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text('End time:',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Text('12:30 pm'),
                                      Text('01:30 pm')
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          color: Color.fromARGB(255, 234, 221, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30))
                          ),
                          elevation: 10,
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.12,
                        child: Card(
                          child: TextButton(
                            child: Text('Update upcoming\nlunch status',
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.normal),),
                            onPressed: () {
                              Navigator.pushNamed(context, RouteManagement.updateUpcomingStatus);
                            },
                          ),
                          color: Color.fromARGB(255, 234, 221, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30))
                          ),
                          elevation: 10,
                        ),
                      ),
                    ),
                    SizedBox(width: 40,),
                  ],
                ),
              ),
            ],
          )

      ),
    );
  }

  Widget _options({required color, required text}){
    return Row(
      children: [
        Icon(Icons.circle,
          color: color,
        ),
        text,
      ],
    );
  }

  Widget _radioButtons({required provider, required text, required value}){
    return RadioListTile<int>(
        title: Text(text),
        value: value,
        groupValue: provider.getRadioValue,
        onChanged: (value) {
          provider.setRadioValue(value);
        }
    );
  }
}