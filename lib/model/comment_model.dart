import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String uid;
  String id;
  String userName;
  String comment;
  final datePublish;
  List likes;
  String displayPhoto;
  CommentModel(
      {required this.uid,
      required this.id,
      required this.userName,
      required this.comment,
      required this.likes,
      required this.displayPhoto,
      required this.datePublish});
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'id': id,
        'userName': userName,
        'comment': comment,
        'datePublish': datePublish,
        'likes': likes,
        'displayPhoto': displayPhoto,
      };

  static CommentModel fromJson(DocumentSnapshot snapshot) {
    var dataFromSnap = snapshot.data() as Map<String, dynamic>;
    return CommentModel(
        uid: dataFromSnap["uid"],
        id: dataFromSnap["id"],
        userName: dataFromSnap["userName"],
        comment: dataFromSnap["comment"],
        likes: dataFromSnap['likes'],
        displayPhoto: dataFromSnap['displayPhoto'],
        datePublish: dataFromSnap['datePublish']);
  }
}
