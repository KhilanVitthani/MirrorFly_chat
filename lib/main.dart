import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mirrorfly_plugin/flychat.dart';

import 'app/routes/app_pages.dart';
import 'common/main_controller.dart';
import 'data/session_management.dart';
import 'model/reply_hash_map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Mirrorfly.init(
      baseUrl: 'https://api-preprod-sandbox.mirrorfly.com/api/v1/',
      licenseKey: 'ucCludha6EAR598zjAxO9iPNxbao2P',
      iOSContainerID: 'group.com.mirrorfly.flutter');
  await SessionManagement.onInit();

  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      onInit: () {
        ReplyHashMap.init();
        Get.put<MainController>(MainController());
      },
    ),
  );
}
