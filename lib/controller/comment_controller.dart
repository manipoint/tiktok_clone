import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

import '../model/comment_model.dart';

class CommentController extends GetxController {
  static CommentController instance = Get.find();
  final Rx<List<CommentModel>> _comment = Rx<List<CommentModel>>([]);
  static String commentCollection = "comments";
  List<CommentModel> get comments => _comment.value;
  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comment.bindStream(firebaseFirestore
        .collection(mediaController.videosCollection)
        .doc(_postId)
        .collection(commentCollection)
        .snapshots()
        .map((event) {
      List<CommentModel> commentList = [];
      for (var element in event.docs) {
        commentList.add(CommentModel.fromJson(element));
      }
      return commentList;
    }));
  }

  postComment(String comment) async {
    try {
      if (comment.isNotEmpty) {
        DocumentSnapshot userData = await firebaseFirestore
            .collection("users")
            .doc(authController.user.uid)
            .get();
        var commentData = await firebaseFirestore
            .collection(mediaController.videosCollection)
            .doc(_postId)
            .collection(commentCollection)
            .get();
        int commentLength = commentData.docs.length;
        CommentModel commentModel = CommentModel(
            uid: authController.user.uid,
            id: 'comment $commentLength',
            userName: (userData.data() as dynamic)['name'],
            comment: comment.trim(),
            likes: [],
            displayPhoto: (userData.data() as dynamic)["displayPhoto"],
            datePublish: DateTime.now());
        await firebaseFirestore
            .collection(mediaController.videosCollection)
            .doc(_postId)
            .collection(commentCollection)
            .doc('comment $commentLength')
            .set(commentModel.toJson());
        DocumentSnapshot documentSnapshot = await firebaseFirestore
            .collection(mediaController.videosCollection)
            .doc(_postId)
            .get();
        await firebaseFirestore
            .collection(mediaController.videosCollection)
            .doc(_postId)
            .update({
          'commentCount':
              (documentSnapshot.data() as dynamic)['commentCount'] + 1,
        });
      }
    } on FirebaseException catch (err) {
      Get.snackbar(
        'Error While Commenting',
        err.toString(),
      );
      if (kDebugMode) {
        print('Error While Commenting ${err.toString()}');
      }
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(mediaController.videosCollection)
        .doc(_postId)
        .collection(commentCollection)
        .doc(id)
        .get();
    if ((snapshot.data() as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore
          .collection(mediaController.videosCollection)
          .doc(_postId)
          .collection(commentCollection)
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firebaseFirestore
          .collection(mediaController.videosCollection)
          .doc(_postId)
          .collection(commentCollection)
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
