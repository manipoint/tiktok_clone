import 'package:cloud_firestore/cloud_firestore.dart';

import '../const/firestore_const.dart';

class MessagesModel {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;
  MessagesModel({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });
  factory MessagesModel.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreConstants.idFrom);
    String idTo = documentSnapshot.get(FirestoreConstants.idTo);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
    String content = documentSnapshot.get(FirestoreConstants.content);
    int type = documentSnapshot.get(FirestoreConstants.type);

    return MessagesModel(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }

  Map<String, dynamic> toJson() => {
        FirestoreConstants.idFrom: idFrom,
        FirestoreConstants.idTo: idTo,
        FirestoreConstants.timestamp: timestamp,
        FirestoreConstants.content: content,
        FirestoreConstants.type: type,
      };
}
