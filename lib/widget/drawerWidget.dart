// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:AstroGuru/controllers/advancedPanchangController.dart';
import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/callController.dart';
import 'package:AstroGuru/controllers/counsellorController.dart';
import 'package:AstroGuru/controllers/follow_astrologer_controller.dart';
import 'package:AstroGuru/controllers/history_controller.dart';
import 'package:AstroGuru/controllers/homeController.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/controllers/themeController.dart';
import 'package:AstroGuru/views/freeServicesScreen.dart';
import 'package:AstroGuru/views/getReportScreen.dart';
import 'package:AstroGuru/views/loginScreen.dart';
import 'package:AstroGuru/views/myFollowingScreen.dart';
import 'package:AstroGuru/views/profile/editUserProfileScreen.dart';
import 'package:AstroGuru/views/settings/colorPicker.dart';
import 'package:AstroGuru/views/settings/settingsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:store_redirect/store_redirect.dart';

import '../controllers/settings_controller.dart';
import '../utils/images.dart';
import '../views/counsellor/counsellorScreen.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);
  final SplashController splashController = Get.find<SplashController>();
  CallController callController = Get.put(CallController());
  PanchangController panchangController = Get.find<PanchangController>();
  HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: GetBuilder<SplashController>(builder: (splashController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 38.0, left: 20, bottom: 10),
                child: GestureDetector(
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      global.showOnlyLoaderDialog(context);
                      await splashController.getCurrentUserData();
                      global.hideLoader();
                      Get.to(() => EditUserProfile());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
                        child: Container(
                          height: 140,
                          width: 140,
                          alignment: Alignment.center,
                          child: splashController.currentUser?.profile == ""
                              ? CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    Images.deafultUser,
                                    fit: BoxFit.fill,
                                    height: 50,
                                  ))
                              : CachedNetworkImage(
                                  imageUrl: "${global.imgBaseurl}${splashController.currentUser?.profile}",
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage("${global.imgBaseurl}${splashController.currentUser?.profile}"),
                                    );
                                  },
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) {
                                    return CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          Images.deafultUser,
                                          fit: BoxFit.fill,
                                          height: 50,
                                        ));
                                  },
                                ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                splashController.currentUser == null
                                    ? "user"
                                    : splashController.currentUser!.name == ""
                                        ? "User"
                                        : "${splashController.currentUser!.name}",
                                style: Get.textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ).translate(),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.edit,
                                size: 15,
                              )
                            ],
                          ),
                          splashController.currentUser == null ? const SizedBox() : Text('${splashController.currentUser!.countryCode}-${splashController.currentUser!.contactNo}')
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                    bottomNavigationController.astrologerList = [];
                    bottomNavigationController.astrologerList.clear();
                    bottomNavigationController.isAllDataLoaded = false;
                    bottomNavigationController.update();
                    global.showOnlyLoaderDialog(context);
                    await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                    global.hideLoader();
                    Get.to(() => GetReportScreen());
                  },
                  child: _drawerItem(icon: Icons.note_alt, title: 'Get Report')),
              GetBuilder<BottomNavigationController>(builder: (navController) {
                return GestureDetector(
                    onTap: () async {
                      global.showOnlyLoaderDialog(context);
                      navController.astrologerList = [];
                      navController.astrologerList.clear();
                      navController.isAllDataLoaded = false;
                      navController.update();
                      await navController.getAstrologerList(isLazyLoading: false);
                      global.hideLoader();
                      navController.setBottomIndex(1, 0);
                    },
                    child: _drawerItem(icon: Icons.circle_rounded, title: 'Chat With Astrologers'));
              }),
              GetBuilder<CounsellorController>(builder: (counsellorController) {
                return GestureDetector(
                    onTap: () async {
                      global.showOnlyLoaderDialog(context);
                      counsellorController.counsellorList = [];
                      counsellorController.update();
                      await counsellorController.getCounsellorsData(false);
                      global.hideLoader();
                      Get.to(() => CounsellorScreen());
                      //navController.setBottomIndex(2, 0);
                    },
                    child: _drawerItem(icon: Icons.person_outline, title: 'Chat With Counsellors'));
              }),
              GestureDetector(
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      final FollowAstrologerController followAstrologerController = Get.find<FollowAstrologerController>();
                      followAstrologerController.followedAstrologer.clear();
                      followAstrologerController.isAllDataLoaded = false;
                      global.showOnlyLoaderDialog(context);
                      await followAstrologerController.getFollowedAstrologerList(false);
                      global.hideLoader();
                      Get.to(() => MyFollowingScreen());
                    }
                  },
                  child: _drawerItem(icon: Icons.verified_user, title: 'My Following')),
              GetBuilder<HomeController>(builder: (homeController) {
                return GestureDetector(
                    onTap: () async {
                      DateTime datePanchang = DateTime.now();
                      int formattedYear = int.parse(DateFormat('yyyy').format(datePanchang));
                      int formattedDay = int.parse(DateFormat('dd').format(datePanchang));
                      int formattedMonth = int.parse(DateFormat('MM').format(datePanchang));
                      int formattedHour = int.parse(DateFormat('HH').format(datePanchang));
                      int formattedMint = int.parse(DateFormat('mm').format(datePanchang));
                      global.showOnlyLoaderDialog(context);
                      await homeController.getBlog();
                      await homeController.getAstrologyVideos();
                      await panchangController.getPanchangDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear);
                      global.hideLoader();
                      Get.to(() => FreeServiceScreen());
                    },
                    child: _drawerItem(icon: Icons.usb_rounded, title: 'Free Services'));
              }),
              GetBuilder<ThemeController>(builder: (themeController) {
                return GestureDetector(
                    onTap: () async {
                      Get.to(() => ColorPickerPage());
                    },
                    child: _drawerItem(icon: Icons.brightness_2, title: 'Theme'));
              }),
              GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      StoreRedirect.redirect(
                        androidAppId: "com.example.astrologer_app",
                      );
                    }
                  },
                  child: _drawerItem(icon: Icons.person, title: 'Sign Up as Astrologer')),
              global.currentUserId != null
                  ? GestureDetector(
                      onTap: () async {
                        SettingsController settingsController = Get.find<SettingsController>();
                        global.showOnlyLoaderDialog(context);
                        await settingsController.getBlockAstrologerList();
                        global.hideLoader();
                        Get.to(() => SettingListScreen());
                      },
                      child: _drawerItem(icon: Icons.settings, title: 'Settings'))
                  : GestureDetector(
                      onTap: () {
                        Get.off(() => LoginScreen());
                      },
                      child: _drawerItem(icon: Icons.arrow_circle_right_outlined, title: 'Login')),
              SizedBox(
                height: 50,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _drawerItem({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Row(children: [
        Icon(
          icon,
          color: Colors.black45,
          size: 18,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          title,
          style: Get.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal, fontSize: 13),
        ).translate(),
      ]),
    );
  }
}
