import 'package:get/get.dart';

import '../controllers/forwardchat_controller.dart';

class ForwardChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForwardChatController());
  }
}
