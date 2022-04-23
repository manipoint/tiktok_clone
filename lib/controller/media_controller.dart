import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/view/pages/conform_page.dart';
import 'package:video_compress/video_compress.dart';

import '../model/video_model.dart';

class MediaController extends GetxController {
  static MediaController instance = Get.find();
  late Rx<XFile?> pickedImage;
  final Rx<List<Video>> videoList = Rx<List<Video>>([]);

  dynamic _pickImageError;

  late TextEditingController songController;
  late TextEditingController captionController;

  XFile? get displayPhoto => pickedImage.value;
  @override
  void onInit() {
    super.onInit();
    pickedImage = Rxn<XFile>();
    videoList.bindStream(getVideos());
    songController = TextEditingController();
    captionController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    videoList.close();
    pickedImage.close();
    songController.clear();
    captionController.clear();
  }
//video section

  Stream<List<Video>> getVideos() => videosCollection.snapshots().map((event) {
        List<Video> retVal = [];
        for (var element in event.docs) {
          retVal.add(Video.fromSnap(element));
        }
        return retVal;
      });

  pickVideo(ImageSource imageSource) async {
    try {
      final pickedVideo = await ImagePicker().pickVideo(source: imageSource);

      if (pickedVideo != null) {
        Get.to(() => ConfirmPage(
              videoPath: pickedVideo.path,
              videoFile: File(pickedVideo.path),
            ));
      }
    } catch (err) {
      Get.snackbar("Error", "Unable to get Video");
      if (kDebugMode) {
        print("Error taking picture from $imageSource : ${err.toString()}");
      }
    }
  }

  selectVideo(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Select video ",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text("Record Video with Camera"),
              onPressed: () {
                pickVideo(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
                child: const Text("Select Video from Gallery"),
                onPressed: () {
                  pickVideo(ImageSource.gallery);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  likeVideos(String id) async {
    try {
      DocumentSnapshot doc =
          await firebaseFirestore.collection('videos').doc(id).get();
      var uid = authController.user.uid;
      if ((doc.data()! as dynamic)['likes'].contains(uid)) {
        await firebaseFirestore.collection('videos').doc(id).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore.collection('videos').doc(id).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } on FirebaseException catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  _compressVideo(String path) async {
    final compressedVideo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String path) async {
    Reference reference = storage.ref().child('videos').child(id);
    UploadTask uploadTask = reference.putFile(await _compressVideo(path));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  _getThumbnail(String path) async {
    final thumbnail = await VideoCompress.getFileThumbnail(path);
    return thumbnail;
  }

  Future<String> _uploadThumbnailToStorage(String id, String path) async {
    Reference reference = storage.ref().child('thumbnail').child(id);
    UploadTask uploadTask = reference.putFile(await _getThumbnail(path));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String songName, String caption, String path) async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      var videoDoc = await firebaseFirestore.collection('videos').get();
      int videoLength = videoDoc.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $videoLength", path);
      String thumbnail =
          await _uploadThumbnailToStorage("Video $videoLength", path);
      Video video = Video(
          username: (documentSnapshot.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $videoLength",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto: (documentSnapshot.data()!
              as Map<String, dynamic>)['displayPhoto'],
          thumbnail: thumbnail);
      await videosCollection.doc("Video $videoLength").set(video.toJson());

      Get.back();
    } catch (err) {
      Get.snackbar(
        'Error Uploading Video',
        err.toString(),
      );
      if (kDebugMode) {
        print("Error while video upload : ${err.toString()}");
      }
    }
  }
  //Image section

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Choose Photo ",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text("Photo with Camera"),
              onPressed: () {
                pickImageFromGallery(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
                child: const Text("Image from Gallery"),
                onPressed: () {
                  pickImageFromGallery(ImageSource.gallery);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  previewImage() {
    if (pickedImage.value != null) {
      if (kIsWeb) {
        return Image.network(pickedImage.value!.path);
      } else {
        return Semantics(
            child: Image.file(File(pickedImage.value!.path)), label: 'image');
      }
    } else if (_pickImageError != null) {
      return Get.snackbar("Error", _pickImageError, colorText: Colors.red);
    } else {
      return Get.snackbar("Error", "You have not yet picked an image",
          colorText: Colors.red);
    }
  }

  Future<String> upload(File image) async {
    Reference reference =
        storage.ref().child("displayImages").child(auth.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  pickImageFromGallery(ImageSource imageSource) async {
    try {
      final _pickedImage = await ImagePicker().pickImage(
        source: imageSource,
      );
      pickedImage.value = _pickedImage;
    } catch (err) {
      Get.snackbar("Error", "Unable to get Image");
      if (kDebugMode) {
        print("Error choosing picture from $imageSource: ${err.toString()}");
      }
    }
  }
}
