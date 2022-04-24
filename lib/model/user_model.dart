import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? displayPhoto;
  String? email;
  String? uid;
  UserModel({
    required this.name,
    required this.displayPhoto,
    required this.email,
    required this.uid,
  });
  static UserModel fromSnap(DocumentSnapshot data) {
    var snapshot = data.data() as Map<String, dynamic>;
    return UserModel(
        name: snapshot["name"],
        displayPhoto: snapshot["displayPhoto"],
        email: snapshot["email"],
        uid: snapshot["uid"]);
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "displayPhoto": displayPhoto, "email": email, "uid": uid};

  UserModel copyWith({
    String? name,
    String? displayPhoto,
    String? email,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      displayPhoto: displayPhoto ?? this.displayPhoto,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }
}
