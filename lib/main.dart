import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/controller/home_controller.dart';
import 'package:tiktok_clone/routes/app_routes.dart';

import 'const/constants.dart';
import 'controller/media_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization.then(
    (value) {
      Get.put(HomeController());
      Get.put(AuthController());
       Get.put(MediaController());
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(scaffoldBackgroundColor: backgroundColor),
      initialRoute: "/login",
      getPages: AppRoutes.routes,
    );
  }
}
