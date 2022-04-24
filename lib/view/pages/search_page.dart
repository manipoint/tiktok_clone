import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/const/all_const.dart';
import 'package:tiktok_clone/controller/search_controller.dart';
import 'package:tiktok_clone/model/user_model.dart';
import 'package:tiktok_clone/view/pages/profile_page.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            onFieldSubmitted: (value) => searchController.searchUser(value),
            decoration: const InputDecoration(
              filled: false,
              hintText: "Search",
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: searchController.searchedUsers.isEmpty
            ? const Center(
                child: Text(
                  "Search Users",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (_, index) {
                  UserModel userModel = searchController.searchedUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: InkWell(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.dimen_30),
                          child: Image.network(
                            userModel.displayPhoto!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            loadingBuilder:
                                (_, child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator.adaptive(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (_, object, stackTrace) {
                              return const Icon(Icons.account_circle, size: 50);
                            },
                          ),
                        ),
                        title: Text(
                          userModel.name!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () =>
                          Get.to(() => ProfilePage(uid: userModel.uid!)),
                    ),
                  );
                }),
      );
    });
  }
}
