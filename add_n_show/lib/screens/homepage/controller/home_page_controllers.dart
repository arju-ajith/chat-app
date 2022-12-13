import 'package:add_n_show/screens/homepage/model/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class HomePageController extends GetxController {
  final TextEditingController entryController = TextEditingController();
  RxList<Message> entries = RxList<Message>([]);
  RxBool isImageSelected = RxBool(false);
  var senderOn = RxBool(false);
  XFile? image;
  RxString tempString = RxString("");
  RxBool isLocationLoading = RxBool(false);

  Future imageOnPress() async {
    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        isImageSelected.value = true;
        tempString.value = image!.path;
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  void updateController(int index) {
    entries[index].isSelected(!entries[index].isSelected.value);
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void locationOnPress() async {
    isLocationLoading(true);
    String lati = "";
    String longi = "";
    try {
      await determinePosition().then((value) => {
            lati = value.latitude.toString(),
            longi = value.longitude.toString()
          });
      entryController.clear();
      entryController.text = "Latitude : $lati\nLongitude : $longi";
      submitFun();
    } on Exception catch (e) {
      Get.snackbar("", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    isLocationLoading(false);
  }

  void imageCancel() {
    tempString("");
  }
}
