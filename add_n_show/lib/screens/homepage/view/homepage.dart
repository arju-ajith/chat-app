import 'dart:io';

import 'package:add_n_show/screens/homepage/controller/home_page_controllers.dart';
import 'package:add_n_show/screens/homepage/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
          child: Obx((() => controller.tempString.value.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(controller.tempString.value)),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: IconButton(
                                onPressed: (() {
                                  controller.imageCancel();
                                }),
                                icon: const Icon(
                                  Icons.cancel_sharp,
                                  size: 50,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: Get.size.width * 0.50,
                                    child: TextField(
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      onSubmitted: (value) {
                                        controller.submitFun();
                                      },
                                      controller: controller.entryController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Type a message",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                  Obx((() => IconButton(
                                      color: controller.senderOn.value
                                          ? Colors.grey
                                          : Colors.blue,
                                      onPressed: (() {
                                        controller.receiveButtonFun();
                                      }),
                                      icon: const Icon(
                                        Icons.call_received,
                                      )))),
                                  Obx((() => IconButton(
                                      color: controller.senderOn.value
                                          ? Colors.blue
                                          : Colors.grey,
                                      onPressed: (() {
                                        controller.sendButtonFun();
                                      }),
                                      icon: const Icon(
                                        Icons.send,
                                      )))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Obx((() => ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.entries.length,
                          itemBuilder: ((context, index) {
                            return controller
                                    .isReceiver(controller.entries[index].type)
                                ? receivedWidget(controller.entries[index],
                                    (() {
                                    controller.updateController(index);
                                    controller.entries.refresh();
                                  }))
                                : sendWidget(controller.entries[index], () {
                                    controller.updateController(index);
                                    controller.entries.refresh();
                                  });
                          })))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Get.size.width * 0.35,
                                  child: TextField(
                                    style: const TextStyle(color: Colors.blue),
                                    onSubmitted: (value) {
                                      controller.submitFun();
                                    },
                                    controller: controller.entryController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a message",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                Obx((() => IconButton(
                                    color: controller.senderOn.value
                                        ? Colors.grey
                                        : Colors.blue,
                                    onPressed: (() {
                                      controller.receiveButtonFun();
                                    }),
                                    icon: const Icon(
                                      Icons.call_received,
                                    )))),
                                Obx((() => IconButton(
                                    color: controller.senderOn.value
                                        ? Colors.blue
                                        : Colors.grey,
                                    onPressed: (() {
                                      controller.sendButtonFun();
                                    }),
                                    icon: const Icon(
                                      Icons.send,
                                    )))),
                                IconButton(
                                    onPressed: (() {
                                      controller.imageOnPress();
                                    }),
                                    icon: const Icon(Icons.photo)),
                                IconButton(
                                    onPressed: () {
                                      controller.locationOnPress();
                                    },
                                    icon: Obx((() =>
                                        controller.isLocationLoading.value
                                            ? const CupertinoActivityIndicator()
                                            : const Icon(Icons.location_on))))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )))),
    );
  }
}

Widget receivedWidget(Message entry, VoidCallback updateController) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onLongPress: () => updateController(),
      child: Container(
        width: Get.size.width,
        color: entry.isSelected.isTrue ? Colors.grey : Colors.transparent,
        child: Row(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  entry.imagePath == null
                      ? const SizedBox()
                      : Container(
                          height: Get.size.width * 0.30,
                          width: Get.size.width * 0.45,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(entry.imagePath!)))),
                        ),
                  entry.msg == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            entry.msg!,
                            textAlign: TextAlign.start,
                          ),
                        ),
                ],
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    ),
  );
}

Widget sendWidget(Message entry, VoidCallback updateController) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onLongPress: () {
        updateController();
      },
      child: Container(
        width: Get.size.width,
        color: entry.isSelected.isTrue ? Colors.grey : Colors.transparent,
        child: Row(
          children: [
            const Spacer(),
            Card(
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  entry.imagePath == null
                      ? const SizedBox()
                      : Container(
                          height: Get.size.width * 0.30,
                          width: Get.size.width * 0.45,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(entry.imagePath!)))),
                        ),
                  entry.msg == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            entry.msg!,
                            textAlign: TextAlign.start,
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
