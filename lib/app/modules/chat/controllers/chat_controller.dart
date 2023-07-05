import 'package:chat_mirror_fly/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:mirrorfly_plugin/mirrorfly.dart';

class ChatController extends GetxController {
  Profile? profile;
  String userJid = "";
  @override
  Future<void> onInit() async {
    if (Get.arguments != null) {
      profile = Get.arguments as Profile;
    }
    userJid = (await Mirrorfly.getJid("Khilan"))!;
    print(profile!.name);
    Mirrorfly.getMessagesOfJid(profile!.jid.checkNull()).then((value) {
      var data = chatMessageModelFromJson(value);
      print(data.length);
    }).catchError((error) {
      print(error);
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
