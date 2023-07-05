import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mirrorfly_plugin/flychat.dart';
import 'package:mirrorfly_plugin/model/chat_message_model.dart';
import 'package:mirrorfly_plugin/model/register_model.dart';
import 'package:mirrorfly_plugin/model/user_list_model.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    Mirrorfly.registerUser("Khilan").then((value) async {
      // you will get the user registration response
      var userData = registerModelFromJson(value);
      // print(value);
    }).catchError((error) {
      // Register user failed print throwable to find the exception details.
      debugPrint(error.message);
    });

    Mirrorfly.syncContacts(true);
    Mirrorfly.onContactSyncComplete.listen((event) {
      log(event.toString());
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
