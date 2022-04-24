import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/const/constants.dart';
import 'package:tiktok_clone/controller/message_controller.dart';
import 'package:tiktok_clone/model/user_model.dart';

import '../../../const/firestore_const.dart';
import '../../../const/size_const.dart';
import '../../../utils/keybord_utils.dart';
import 'chat_page.dart';

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();

  final MessageController controller = Get.put(MessageController());

  final Rx<int> _limit = 20.obs;
  final Rx<int> _limitIncrement = 20.obs;
  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      _limit.value += _limitIncrement.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('Messages'),
      ),
      body: Obx(() =>Stack(children: [
        Column(
          children: [
            buildSearchBar(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.getFirestoreData(
                    FirestoreConstants.pathUserCollection,
                    _limit.value,
                    controller.textSearch.value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data?.docs.length ?? 0) > 0) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return buildItem(context, snapshot.data?.docs[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      );
                    } else {
                      return const Center(
                        child: Text('No user found...'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        Positioned(
            child: controller.isLoading.value
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )
                : const SizedBox.shrink())
      ],),
    ),);
  }

  buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(Sizes.dimen_10),
      height: Sizes.dimen_50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: Sizes.dimen_10,
          ),
          const Icon(
            Icons.person_search,
            color: Colors.white,
            size: Sizes.dimen_24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              style: const TextStyle(color: Colors.white, fontSize: 22),
              textInputAction: TextInputAction.search,
              controller: controller.searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  controller.buttonClearController.add(true);
                  controller.textSearch.value = value;
                } else {
                  controller.buttonClearController.add(false);
                  controller.textSearch.value = "";
                }
              },
              decoration: const InputDecoration.collapsed(
                hintText: "Search here ....",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          StreamBuilder(builder: (_, snapshot) {
            return snapshot.data == true
                ? GestureDetector(
                    child: const Icon(
                      Icons.clear_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      controller.searchController.clear();
                      controller.buttonClearController.add(false);
                      controller.textSearch.value = '';
                    },
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.dimen_30),
        color: const Color.fromRGBO(43, 58, 103, 1),
      ),
    );
  }

  buildItem(BuildContext context, DocumentSnapshot? snapshot) {
    if (snapshot != null) {
      UserModel userModel = UserModel.fromSnap(snapshot);
      if (userModel.uid == authController.user.uid) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          peerUid: userModel.uid!,
                          peerAvatar: userModel.displayPhoto!,
                          peerName: userModel.name!,
                       
                        )));
          },
          child: ListTile(
            leading: userModel.displayPhoto!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.dimen_30),
                    child: Image.network(
                      userModel.displayPhoto!,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.grey,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
                  
                  title: Text(
              userModel.name!.capitalizeFirst!,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
