import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/model/app_review_model.dart';
import 'package:AstroGuru/model/home_Model.dart';
import 'package:AstroGuru/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/language.dart';
import 'package:AstroGuru/utils/global.dart' as global;

class HomeController extends GetxController {
  List<Language> lan = [];
  APIHelper apiHelper = APIHelper();
  var bannerList = <Banner>[];
  var blogList = <Blog>[];
  var astroNews = <AstrotalkInNews>[];
  var astrologyVideo = <AstrologyVideo>[];
  var clientReviews = <AppReviewModel>[];
  var myOrders = <TopOrder>[];
  final material.TextEditingController feedbackController = material.TextEditingController();
  final SplashController splashController = Get.find<SplashController>();
  final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  material.PageController pageController = material.PageController().obs();
  int reviewChange = 0.obs();
  VideoPlayerController? videoPlayerController;
  VideoPlayerController? homeVideoPlayerController;
  YoutubePlayerController? youtubePlayerController;

  @override
  void onInit() async {
    _init();
    videoPlayerController = VideoPlayerController.network(
      '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.behindScenes)}',
    )..initialize().then((_) {
        videoPlayerController!.pause();
        videoPlayerController!.setLooping(true);

        update();
      });

    super.onInit();
  }

  _init() async {
    await getBanner();
    await getBlog();
    await getAstroNews();
    await getMyOrder();
    await getAstrologyVideos();
    await getClientsTestimonals();
    bottomNavigationController.astrologerList.clear();
    await bottomNavigationController.getAstrologerList(isLazyLoading: false);
  }

  DateTime? currentBackPressTime;
  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      global.showToast(
        message: 'Press again to exit',
        textColor: global.textColor,
        bgColor: global.toastBackGoundColor,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  void playPauseVideo() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      update();
    } else {
      videoPlayerController!.play();
      update();
    }
  }

  void blogplayPauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
      update();
    } else {
      controller.play();
      update();
    }
  }

  Future youtubPlay(String url) async {
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(url);
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: '$videoId',
        flags: YoutubePlayerFlags(
          autoPlay: true,
          showLiveFullscreenButton: true,
        ));
    update();
  }

  homeBlogVideo(String link) {
    homeVideoPlayerController = VideoPlayerController.network(
      '${global.imgBaseurl}$link',
    )..initialize().then((_) {
        homeVideoPlayerController!.pause();
        homeVideoPlayerController!.setLooping(true);
        update();
      });
  }

  int selectedIndex = 0;
  updateLan(int index) {
    selectedIndex = index;
    lan[index].isSelected = true;
    update();
    for (int i = 0; i < lan.length; i++) {
      if (i == index) {
        continue;
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    update();
  }

  updateLanIndex() async {
    global.sp = await SharedPreferences.getInstance();
    var currentLan = global.sp!.getString('currentLanguage') ?? 'en';
    for (int i = 0; i < lan.length; i++) {
      if (lan[i].lanCode == currentLan) {
        selectedIndex = i;
        lan[i].isSelected = true;
        update();
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    print(selectedIndex);
  }

  bool checkBannerValid({required DateTime startDate, required DateTime endDate}) {
    DateTime now = DateTime.now();
    // end date is after or today and sart date is before or today show add
    if (startDate.isBefore(now) && endDate.isAfter(now)) {
      return true;
    }
    return false;
  }

  getBanner() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeBanner().then((result) {
            if (result.status == "200") {
              bannerList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get banner',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBanner:-" + e.toString());
    }
  }

  getBlog() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeBlog().then((result) {
            if (result.status == "200") {
              blogList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Blogs',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBlog:-" + e.toString());
    }
  }

  getAstroNews() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroNews().then((result) {
            if (result.status == "200") {
              astroNews = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get astro news',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstroNews:-" + e.toString());
    }
  }

  getMyOrder() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeOrder().then((result) {
            if (result.status == "200") {
              myOrders = result.recordList;
              print("my order length ${myOrders.length}");
              update();
              print('order gett');
            } else {
              global.showToast(
                message: 'Failed to get my orders',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      myOrders.clear();
      update();
      print("Exception in getMyOrder:-" + e.toString());
    }
  }

  getAstrologyVideos() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroVideos().then((result) {
            if (result.status == "200") {
              astrologyVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }
  }

  getClientsTestimonals() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAppReview().then((result) {
            if (result.status == "200") {
              clientReviews = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get client testimonals',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
  }

  incrementBlogViewer(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.viewerCount(id).then((result) {
            if (result.status == "200") {
              print('success');
            } else {
              global.showToast(
                message: 'Faild to increment blog viewer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in incrementBlogViewer:- " + e.toString());
    }
  }

  addFeedback(String review) async {
    var appReviewModel = {
      "appId": global.appId,
      "review": review,
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAppFeedback(appReviewModel).then((result) {
            if (result.status == "200") {
              feedbackController.text = '';

              global.showToast(
                message: 'Thank you!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed to add feedback',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- " + e.toString());
    }
  }

  getLanguages() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getLanguagesForMultiLanguage().then((result) {
            global.hideLoader();
            if (result.status == "200") {
              lan.addAll(result.recordList);
              update();
            } else {
              global.showToast(
                message: 'Failed to get language!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getLanguages():- " + e.toString());
    }
  }
}
