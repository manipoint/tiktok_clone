
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tiktok_clone/view/pages/profile_page.dart';

import 'package:tiktok_clone/view/widgets/custom_icon.dart';

import '../../constants.dart';
import 'add_video_page.dart';
import 'search_page.dart';
import 'video_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  onPageChange(int page) {
    homeController.currentIndex.value = page;
  }
@override
  Widget build(BuildContext context) {
return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          key: key,
          children: [
            const VideoPage(),
           const SearchPage(),
             const AddVideoPage(),
             const Center(child: Text('Message'),),
           
            ProfilePage(uid: auth.currentUser!.uid)
          ],
          controller: homeController.pageController,
        ),
      ),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          itemPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
        
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            SalomonBottomBarItem(
             icon: const Icon(Icons.search),
              title: const Text('Search'),
            ),
            SalomonBottomBarItem(
              icon: CustomIcon(),
              title: const Text(''),
            ),
             SalomonBottomBarItem(
              icon: const Icon(Icons.message),
              title: const Text('message'),
            ),
            
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_box),
              title: const Text('Profile'),
             
            ),
          ],
          onTap: (position) {
            homeController.currentIndex.value = position;
            homeController.pageController.jumpToPage(position);
          },
          currentIndex: homeController.currentIndex.value,
          
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.red,
          
        ),
      ),
    );
  }
}