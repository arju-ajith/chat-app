import 'package:add_n_show/screens/homepage/model/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePageController extends GetxController {
  final TextEditingController entryController = TextEditingController();
  RxList<Message> entries = RxList(<Message>[]);
  RxBool isImageSelected = RxBool(false);
  var senderOn = RxBool(false);
  XFile? image;
  RxString tempString = RxString("");

  Future imageOnPress() async {
    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        isImageSelected.value = true;
        tempString.value = image!.path;
      }
    } on Exception catch (e) {
      print("Error : $e");
    }
  }

  void receivedMsg() {
    if (entryController.text.isNotEmpty || image != null) {
      entries.add(Message(1,
          imagePath: image != null ? image!.path : null,
          msg: entryController.text.isEmpty ? null : entryController.text));
      entryController.clear();
      image = null;
    } else {
      Get.snackbar("", "Please enter the valid entry!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void sendMsg() {
    if (entryController.text.isNotEmpty || image != null) {
      entries.add(Message(2,
          imagePath: image != null ? image!.path : null,
          msg: entryController.text.isEmpty ? null : entryController.text));
      entryController.clear();
      image = null;
    } else {
      Get.snackbar("", "Please enter the valid entry!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  bool isReceiver(int type) {
    if (type == 1) {
      return true;
    } else {
      return false;
    }
  }

  void changeType() {
    senderOn.value = !senderOn.value;
  }

  void submitFun() {
    senderOn.value ? sendMsg() : receivedMsg();
    tempString.value = "";
  }

  void sendButtonFun() {
    senderOn.value ? () {} : changeType();
  }

  void receiveButtonFun() {
    senderOn.value ? changeType() : () {};
  }
}
