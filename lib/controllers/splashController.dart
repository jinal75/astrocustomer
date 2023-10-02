import 'dart:async';
import 'dart:convert';
import 'package:AstroGuru/controllers/bottomNavigationController.dart';

import 'package:AstroGuru/controllers/homeController.dart';
import 'package:AstroGuru/controllers/reviewController.dart';
import 'package:AstroGuru/model/current_user_model.dart';
import 'package:AstroGuru/model/systemFlagModel.dart';
import 'package:AstroGuru/utils/services/api_helper.dart';
import 'package:AstroGuru/views/loginScreen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/astrologerProfile/astrologerProfile.dart';
import '../views/bottomNavigationBarScreen.dart';
import '../views/call/incoming_call_request.dart';
import '../views/chat/incoming_chat_request.dart';

class SplashController extends GetxController {
  APIHelper apiHelper = APIHelper();
  CurrentUserModel? currentUser;
  CurrentUserModel? currentUserPayment;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? appShareLinkForLiveSreaming;
  String? version;
  double? totalGst;
  var syatemFlag = <SystemFlag>[];
  String appName = "";
  String currentLanguageCode = 'en';
  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    await getSystemFlag();
    appName = global.getSystemFlagValueForLogin(global.systemFlagNameList.appName);
    global.sp = await SharedPreferences.getInstance();
    currentLanguageCode = global.sp!.getString('currentLanguage') ?? 'en';
    update();
    Timer(const Duration(seconds: 5), () async {
      try {
        bool isLogin = await global.isLogin();
        if (isLogin) {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          await global.checkBody().then((result) async {
            if (result) {
              await apiHelper.validateSession().then((result) async {
                if (result.status == "200") {
                  currentUser = result.recordList;
                  global.saveUser(currentUser!);
                  global.user = currentUser!;
                  await getCurrentUserData();
                  await global.getCurrentUser();
                  if (global.generalPayload != null) {
                    Map<String, dynamic> convetedPayLoad = json.decode(global.generalPayload);
                    Map<String, dynamic> body = jsonDecode(convetedPayLoad['body']);
                    print("Yes general pay load called" + body.toString());
                    if (body["notificationType"] == 1) {
                      Get.to(() => IncomingCallRequest(
                            astrologerId: body["astrologerId"],
                            astrologerName: body["astrologerName"] == null ? "Astrologer" : body["astrologerName"],
                            astrologerProfile: body["profile"] == null ? "" : body["profile"],
                            token: body["token"],
                            channel: body["channelName"],
                            callId: body["callId"],
                            fcmToken: body["fcmToken"] ?? "",
                          ));
                    } else if (body["notificationType"] == 3) {
                      Get.to(() => IncomingChatRequest(
                            astrologerName: body["astrologerName"] == null ? "Astrologer" : body["astrologerName"],
                            profile: body["profile"] == null ? "" : body["profile"],
                            fireBasechatId: body["firebaseChatId"],
                            chatId: body["chatId"],
                            astrologerId: body["astrologerId"],
                            fcmToken: body["fcmToken"],
                          ));
                    } else if (body["notificationType"] == 4) {
                      print('live astrologer');
                      Get.find<ReviewController>().getReviewData(body["astrologerId"]);
                      await Get.find<BottomNavigationController>().getAstrologerbyId(body["astrologerId"]);
                      Get.to(() => AstrologerProfile(index: 0));
                    } else {
                      print('other notification');
                    }
                  } else {
                    BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                    bottomNavigationController.setIndex(0, 0);

                    Get.off(() => BottomNavigationBarScreen(index: 0));
                  }
                } else {
                  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                    version = packageInfo.version;
                    update();
                  });
                  HomeController homeController = Get.find<HomeController>();
                  homeController.myOrders.clear();
                  Get.off(() => LoginScreen());
                }
              });
            }
          });
        } else {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          Get.off(() => LoginScreen());
        }
      } catch (e) {
        print('Exception in _inIt():' + e.toString());
      }
    });
  }

  Future<void> createAstrologerShareLink() async {
    try {
      global.showOnlyLoaderDialog(Get.context);
      String appShareLink;
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://astroguruupdated.page.link',
        link: Uri.parse("https://astroguruupdated.page.link/userProfile?screen=astrologerShare"),
        androidParameters: AndroidParameters(
          packageName: 'com.AstroGuru.app',
          minimumVersion: 1,
        ),
      );
      Uri url;
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
      url = shortLink.shortUrl;
      appShareLink = url.toString();
      appShareLinkForLiveSreaming = appShareLink;
      update();
      global.hideLoader();
      await FlutterShare.share(
        title: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
        text: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
        linkUrl: '$appShareLinkForLiveSreaming',
      );
    } catch (e) {
      print("Exception - global.dart - referAndEarn():" + e.toString());
    }
  }

  getCurrentUserData() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.sp = await SharedPreferences.getInstance();
          await apiHelper.getCurrentUser().then((result) {
            if (result.status == "200") {
              currentUser = result.recordList;
              global.saveUser(currentUser!);
              global.user = currentUser!;
              print('current user profile from splash ${global.user.profile}');
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getCurrentUserData():' + e.toString());
    }
  }

  getSystemFlag() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.sp = await SharedPreferences.getInstance();
          await apiHelper.getSystemFlag().then((result) {
            if (result.status == "200") {
              syatemFlag = result.recordList;
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getSystemFlag():' + e.toString());
    }
  }
}
