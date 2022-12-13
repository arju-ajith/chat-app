import 'package:get/get.dart';

class Message {
  final String? msg;
  final int type;
  final String? imagePath;
  RxBool isSelected = RxBool(false);

  Message(this.type, {this.msg, this.imagePath});
}
