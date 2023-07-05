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
      body: Column(
        children: [
          if (controller.selectedUser != null)
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Profile profile = controller.selectedUser!.data![index];
                  return InkWell(
                    onTap: () {
                      controller.toChatPage(profile.jid!);
                    },
                    child: ListTile(
                      title: Text(profile.name!),
                      subtitle: Text(profile.email!),
                      leading: CircleAvatar(
                        child: Text(profile.image!),
                      ),
                    ),
                  );
                },
                itemCount: controller.selectedUser!.data!.length,
              ),
            )
        ],
      ),
    );
  }
}
