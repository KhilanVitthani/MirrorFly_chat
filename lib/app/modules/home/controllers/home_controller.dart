import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mirrorfly_plugin/flychat.dart';
import 'package:mirrorfly_plugin/model/chat_message_model.dart';
import 'package:mirrorfly_plugin/model/register_model.dart';
import 'package:mirrorfly_plugin/model/user_list_model.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // RxList<UserList> userList = RxList<UserList>([]);
  UserList? selectedUser;
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

    Mirrorfly.getUserList(1, "").then((data) {
      log(data);
      var item = userListFromJson(data);
      selectedUser = item;
    }).catchError((error) {});
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

  Future<Profile> getProfileDetails(String jid) async {
    var value = await Mirrorfly.getProfileDetails(jid.checkNull());
    // profileDataFromJson(value);
    debugPrint("update profile--> $value");
    var profile = await compute(profiledata, value.toString());
    // var str = Profile.fromJson(json.decode(value.toString()));
    return profile;
  }

  toChatPage(String jid) {
    if (jid.isNotEmpty) {
      // Helper.progressLoading();
      getProfileDetails(jid).then((value) {
        if (value.jid != null) {
          // Helper.hideLoading();
          // debugPrint("Dashboard Profile===>$value");
          var profile = value; //profiledata(value.toString());
          Get.toNamed(Routes.CHAT, arguments: profile);
        }
      });
      // SessionManagement.setChatJid(jid);
      // Get.toNamed(Routes.chat);
    }
  }
}

extension StringParsing on String? {
  //check null
  String checkNull() {
    return this ?? "";
  }

  bool toBool() {
    return this != null ? this!.toLowerCase() == "true" : false;
  }

  int checkIndexes(String searchedKey) {
    var i = -1;
    if (i == -1 || i < searchedKey.length) {
      while (this!.contains(searchedKey, i + 1)) {
        i = this!.indexOf(searchedKey, i + 1);

        if (i == 0 ||
            (i > 0 &&
                (RegExp("[^A-Za-z0-9 ]").hasMatch(this!.split("")[i]) ||
                    this!.split("")[i] == " "))) {
          return i;
        }
        i++;
      }
    }
    return -1;
  }

  bool startsWithTextInWords(String text) {
    return !this!.toLowerCase().contains(text.toLowerCase())
        ? false
        : this!.toLowerCase().startsWith(text.toLowerCase());
    //checkIndexes(text)>-1;
    /*return when {
      this.indexOf(text, ignoreCase = true) <= -1 -> false
      else -> return this.checkIndexes(text) > -1
    }*/
  }
}
