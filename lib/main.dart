import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mirrorfly_plugin/flychat.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Mirrorfly.init(
      baseUrl: 'https://api-preprod-sandbox.mirrorfly.com/api/v1/',
      licenseKey: 'ucCludha6EAR598zjAxO9iPNxbao2P',
      iOSContainerID: 'group.com.mirrorfly.flutter');
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
