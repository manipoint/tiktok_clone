import 'package:get/get.dart';

import 'package:tiktok_clone/view/pages/auth/login_page.dart';
import 'package:tiktok_clone/view/pages/auth/sign_up_page.dart';

import '../const/constants.dart';
import '../view/pages/add_video_page.dart';
import '../view/pages/conform_page.dart';
import '../view/pages/home_page.dart';
import '../view/pages/profile_page.dart';
import '../view/pages/search_page.dart';
import '../view/pages/video_page.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/sign-up', page: () => SignUpPage()),
    GetPage(name: '/home', page: () => const HomePage()),
    GetPage(name: '/video', page: () => const VideoPage()),
    GetPage(name: '/add-video', page: () => const AddVideoPage()),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(
        name: '/profile',
        page: () => ProfilePage(
              uid: authController.user.uid,
            )),
  ];
}
