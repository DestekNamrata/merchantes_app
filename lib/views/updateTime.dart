import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodbank_marchantise_app/controllers/global-controller.dart';
import 'package:foodbank_marchantise_app/controllers/notification_order_controller.dart';
import 'package:foodbank_marchantise_app/services/api-list.dart';
import 'package:foodbank_marchantise_app/services/server.dart';
import 'package:foodbank_marchantise_app/utils/font_size.dart';
import 'package:foodbank_marchantise_app/utils/images.dart';
import 'package:foodbank_marchantise_app/utils/theme_colors.dart';
import 'package:foodbank_marchantise_app/views/order_details.dart';
import 'package:foodbank_marchantise_app/widgets/loader.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';


class UpdateTime extends StatefulWidget{
  String orderId;
  UpdateTime({Key? key,required this.orderId}):super(key: key);

  UpdateTimeState createState() => UpdateTimeState();
}
class UpdateTimeState extends State<UpdateTime>{
  String acceptDialogue = "Are you sure you want to accept the order?";
  String processDialogue = "Are you sure you want to process the order?";
  String cancelDialogue = "Are you sure you want to cancel the order?";
  String DialogueAccpet = "Order Accept?";

  TextEditingController _timeController = TextEditingController();
  bool loading=false;
  final order_Controller = Get.put(OrderListController());
  Server server = Server();


  //shhow alertDialogue
  showAlertDialog(
      BuildContext context, dialogueAccpet, String alertMessage, status, id) {
    int? oId = int.parse(id);

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        order_Controller.changeStatus(status, id);
        Navigator.of(context).pop();
        Get.off(() => Order_details(orderId: oId));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(dialogueAccpet),
      content: Text(alertMessage),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //to save image and orderId
  updateTime(String time,String id) async {
    // order_Controller.loader = true;
    // Future.delayed(Duration(milliseconds: 10), () {
    //   order_Controller.update();
    // });
    var jsonMap = {
      'waiting_time': time,
    };
    String jsonStr = jsonEncode(jsonMap);
    server
        .putRequest(
        endPoint: APIList.UpdateTime! + id + '/waiting_time',
        body: jsonStr)
        .then((response) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response != null && response.statusCode == 200) {
        // order_Controller.onInit();
        // Future.delayed(Duration(milliseconds: 10), () {
        //   order_Controller.update();
        // });
        setState(() {
          loading=false;
        });
        showAlertDialog(
            context,
            DialogueAccpet,
            acceptDialogue,
            '14',
           id);
        print('upload proccess started');
      } else {
        Get.rawSnackbar(message: 'Please enter valid input');
        Future.delayed(Duration(milliseconds: 10), () {
          order_Controller.update();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderListController>(
        init: OrderListController(),
    builder: (orders) =>Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Order Id: #"+widget.orderId,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: FontSize.xLarge,
              color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image
                  Image(
                    image: AssetImage(Get.isDarkMode
                        ? Images.appLogo
                        : Images.appLogo),
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Time in Mins',
                        labelStyle: TextStyle(
                            color: Colors.grey, fontSize: 14),
                        hintText: 'Enter your waiting time in mins',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 14),

                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: ThemeColors.greyTextColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 0.2,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        onPressed: () {
                          if(_timeController.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter time");

                          }else{
                            // Navigator.of(context).pop();
                            setState(() {
                              loading=true;

                            });
                            updateTime(_timeController.text, widget.orderId);
                          }
                        },
                        child: Text(
                          "Update Time",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: ThemeColors.baseThemeColor,
                      ),
                    ),
                  ),

                ],
              ),
              loading==true
                  ? Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white60,
                  child: Center(
                    child: Loader(),
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ],
          )

        ),
      ),
    ));
  }
}