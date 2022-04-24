import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/media_controller.dart';
import 'package:tiktok_clone/view/pages/profile_page.dart';
import 'package:tiktok_clone/view/widgets/circle_widget.dart';

import '../../const/constants.dart';
import '../widgets/video_player_widget.dart';
import 'comment_page.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<MediaController>(
      init: MediaController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            return PageView.builder(
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemCount: controller.videoList.value.length,
                itemBuilder: (context, index) {
                  final data = controller.videoList.value[index];
                  return (Stack(
                    children: [
                      VideoPlayerWidget(url: data.videoUrl),
                      Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          data.username.replaceFirst(
                                              data.username.characters.first,
                                              data.username.characters.first
                                                  .toUpperCase()),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data.caption,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.music_note,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              data.songName.replaceFirst(
                                                  data.songName.characters
                                                      .first,
                                                  data.songName.characters.first
                                                      .toUpperCase()),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(top: size.height / 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap:()=>Get.to(()=>ProfilePage(uid: data.uid)),
                                      child:buildProfile(data.profilePhoto),),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                controller.likeVideos(data.id),
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              size: 40,
                                              color: data.likes.contains(
                                                      authController.user.uid)
                                                  ? const Color.fromRGBO(
                                                      190, 21, 21, 1)
                                                  : const Color.fromRGBO(
                                                      255, 255, 255, 1),
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                            data.likes.length.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () => Get.to(
                                                () => CommentPage(id: data.id)),
                                            child: const Icon(
                                              Icons.comment,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                            data.commentCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.reply,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                            data.shareCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      CircleWidget(
                                        child:
                                            buildMusicAlbum(data.profilePhoto),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ));
                });
          }),
        );
      },
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: profilePhoto,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: CachedNetworkImageProvider(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }
}
