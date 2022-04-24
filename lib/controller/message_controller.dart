import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/firestore_const.dart';
import '../const/constants.dart';
import '../model/user_model.dart';

class MessageController extends GetxController {
  final Rx<List<UserModel>> _searchedUsers = Rx<List<UserModel>>([]);
  TextEditingController searchController = TextEditingController();
  StreamController<bool> buttonClearController = StreamController<bool>();
  Rx<String> textSearch = "".obs;
  Rx<bool> isLoading = false.obs;

  List<UserModel> get searchedUsers => _searchedUsers.value;
  @override
  void onClose() {
    super.onClose();
    buttonClearController.close();
  }

  searchUser(String search) async {
    _searchedUsers.bindStream(userCollection
        .where('name', isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var elm in event.docs) {
        users.add(UserModel.fromSnap(elm));
      }
      return users;
    }));
  }

  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  Stream<QuerySnapshot> getFirestoreData(
      String collectionPath, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirestoreConstants.displayName, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }
}
