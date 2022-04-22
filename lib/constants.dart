//Colors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controller/media_controller.dart';
import 'package:tiktok_clone/view/pages/home_page.dart';
import 'package:tiktok_clone/view/pages/search_page.dart';

import 'controller/auth_controller.dart';
import 'controller/home_controller.dart';
import 'view/pages/add_video_page.dart';
import 'view/pages/profile_page.dart';
import 'view/pages/video_page.dart';

const backgroundColor = Color.fromRGBO(47, 46, 46, 1);
const buttonColor = Color.fromRGBO(148, 36, 36, 1);
const borderColor = Color.fromRGBO(99, 96, 96, 1);

//firebase
final Future<FirebaseApp> initialization = Firebase.initializeApp();
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;

// getx binding
AuthController authController = AuthController.instance;
HomeController homeController = HomeController.instance;
MediaController mediaController = MediaController.instance;

//pages
List pages = [
  const VideoPage(),
  const SearchPage(),
  const AddVideoPage(),
  const Text("asdf"),
  ProfilePage(uid: authController.user.uid),
];
