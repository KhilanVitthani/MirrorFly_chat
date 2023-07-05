import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mirrorfly_plugin/flychat.dart';
import 'package:mirrorfly_plugin/model/chat_message_model.dart';
import 'package:mirrorfly_plugin/model/user_list_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: InkWell(
        onTap: () async {
          var userJid = await Mirrorfly.getJid("Khilan");
          Mirrorfly.sendTextMessage("message", userJid!).then((value) {
            // you will get the message sent success response
            log(value);
            var chatMessage = sendMessageModelFromJson(value);
            print("Chat User ID" + chatMessage.chatUserJid);
            print("Sendr Id" + chatMessage.senderUserJid);
          });
          // Mirrorfly.getUserList(1, "").then((data) {
          //   log(data);
          //   var item = userListFromJson(data);
          //   // log(item.toString());
          // }).catchError((error) {});
        },
        child: const Center(
          child: Text(
            'HomeView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
