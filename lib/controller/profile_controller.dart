import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../const/constants.dart';




class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  final Rx<String> _uid = "".obs;
  String followingCollection = 'following';
  String followersCollection = 'followers';
  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  void getUserData() async {
    List<String> thumbnail = [];
    var myVideos =
        await videosCollection.where('uid', isEqualTo: _uid.value).get();
    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnail.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userSnap = await userCollection.doc(_uid.value).get();
    final userData = userSnap.data() as dynamic;
    String name = userData['name'];
    String displayPhoto = userData['displayPhoto'];
    int likes = 0;
    int follower = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await userCollection
        .doc(_uid.value)
        .collection(followersCollection)
        .get();
    var followingDoc = await userCollection
        .doc(_uid.value)
        .collection(followingCollection)
        .get();
    follower = followerDoc.docs.length;
    following = followingDoc.docs.length;

    userCollection
        .doc(_uid.value)
        .collection(followersCollection)
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });
    _user.value = {
      'followers': follower.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'displayPhoto': displayPhoto,
      'name': name,
      'thumbnails': thumbnail,
    };
    update();
  }

  followUser() async {
    var doc = await userCollection
        .doc(_uid.value)
        .collection(followersCollection)
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      userCollection
          .doc(_uid.value)
          .collection(followersCollection)
          .doc(authController.user.uid)
          .set({});
      await userCollection
          .doc(authController.user.uid)
          .collection(followingCollection)
          .doc(_uid.value)
          .set({});

      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
    } else {
      await userCollection
          .doc(_uid.value)
          .collection(followersCollection)
          .doc(authController.user.uid)
          .delete();
      await userCollection
          .doc(authController.user.uid)
          .collection(followingCollection)
          .doc(_uid.value)
          .delete();
      _user.value
          .update('followers', (value) => (int.parse(value) - 1).toString());
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
