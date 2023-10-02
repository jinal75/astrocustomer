// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/chatController.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/main.dart';
import 'package:AstroGuru/model/chat_message_model.dart';
import 'package:AstroGuru/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/reviewController.dart';
import '../../controllers/timer_controller.dart';
import '../astrologerProfile/astrologerProfile.dart';

class AcceptChatScreen extends StatelessWidget {
  final int flagId;
  final String profileImage;
  final String astrologerName;
  final String fireBasechatId;
  final int chatId;
  final int astrologerId;
  final String? fcmToken;
  AcceptChatScreen({
    super.key,
    required this.flagId,
    required this.profileImage,
    required this.astrologerName,
    required this.fireBasechatId,
    required this.astrologerId,
    required this.chatId,
    this.fcmToken,
  });
  final TextEditingController messageController = TextEditingController();
  final SplashController splashController = Get.find<SplashController>();
  final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  TimerController timerController = Get.find<TimerController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (flagId == 0) {
          return true;
        } else {
          TimerController timerController = Get.find<TimerController>();
          if (chatController.isAstrologerEndedChat != true) {
            if (timerController.totalSeconds < 60) {
              Get.dialog(
                AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  titlePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  title: Text(
                    "You can end chat after one minute",
                    style: Get.textTheme.subtitle1,
                  ).translate(),
                  content: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Ok', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                  ),
                ),
              );
            } else {
              Get.dialog(
                AlertDialog(
                  title: Text(
                    "Are you sure you want to end chat?",
                    style: Get.textTheme.subtitle1,
                  ).translate(),
                  content: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          global.showOnlyLoaderDialog(context);
                          final ChatController chatController = Get.find<ChatController>();
                          chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                          chatController.showBottomAcceptChat = false;
                          global.sp = await SharedPreferences.getInstance();
                          global.sp!.remove('chatBottom');
                          global.sp!.setInt('chatBottom', 0);
                          chatController.isEndChat = true;
                          chatController.chatBottom = false;
                          chatController.isInchat = false;
                          chatController.isAstrologerEndedChat = false;
                          global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                          chatController.update();
                          await timerController.endChatTime(timerController.totalSeconds, chatId);
                          global.hideLoader();
                          timerController.min = 0;
                          timerController.minText = "";
                          timerController.sec = 0;
                          timerController.secText = "";
                          timerController.secTimer!.cancel();
                          timerController.endChat = true;
                          timerController.update();
                          bottomNavigationController.astrologerList.clear();
                          bottomNavigationController.isAllDataLoaded = false;
                          if (bottomNavigationController.genderFilterList != null) {
                            bottomNavigationController.genderFilterList!.clear();
                          }
                          if (bottomNavigationController.languageFilter != null) {
                            bottomNavigationController.languageFilter!.clear();
                          }
                          if (bottomNavigationController.skillFilterList != null) {
                            bottomNavigationController.skillFilterList!.clear();
                          }
                          bottomNavigationController.applyFilter = false;
                          bottomNavigationController.update();
                          await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                          Get.back();
                          Get.back();
                          Get.back();
                        },
                        child: Text('Yes', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          timerController.endChat = false;
                          timerController.update();
                        },
                        child: Text('No', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                      ),
                    ],
                  ),
                ),
              );
            }
            return timerController.endChat;
          } else {
            Get.dialog(
              AlertDialog(
                title: Text(
                  "Are you sure you want to end chat?",
                  style: Get.textTheme.subtitle1,
                ).translate(),
                content: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        global.showOnlyLoaderDialog(context);
                        final ChatController chatController = Get.find<ChatController>();
                        chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                        chatController.showBottomAcceptChat = false;
                        global.sp = await SharedPreferences.getInstance();
                        global.sp!.remove('chatBottom');
                        global.sp!.setInt('chatBottom', 0);
                        chatController.isEndChat = true;
                        chatController.chatBottom = false;
                        chatController.isInchat = false;
                        chatController.isAstrologerEndedChat = false;
                        global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                        chatController.update();
                        await timerController.endChatTime(timerController.totalSeconds, chatId);
                        global.hideLoader();
                        timerController.min = 0;
                        timerController.minText = "";
                        timerController.sec = 0;
                        timerController.secText = "";
                        timerController.secTimer!.cancel();
                        timerController.endChat = true;
                        timerController.update();
                        bottomNavigationController.astrologerList.clear();
                        bottomNavigationController.isAllDataLoaded = false;
                        if (bottomNavigationController.genderFilterList != null) {
                          bottomNavigationController.genderFilterList!.clear();
                        }
                        if (bottomNavigationController.languageFilter != null) {
                          bottomNavigationController.languageFilter!.clear();
                        }
                        if (bottomNavigationController.skillFilterList != null) {
                          bottomNavigationController.skillFilterList!.clear();
                        }
                        bottomNavigationController.applyFilter = false;
                        bottomNavigationController.update();
                        await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                        Get.back();
                        Get.back();
                        Get.back();
                      },
                      child: Text('Yes', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        timerController.endChat = false;
                        timerController.update();
                      },
                      child: Text('No', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                    ),
                  ],
                ),
              ),
            );
            return timerController.endChat;
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
            title: GestureDetector(
              onTap: () async {
                print('appbar tapped');
                if (flagId == 0) {
                  Get.find<ReviewController>().getReviewData(astrologerId);
                  global.showOnlyLoaderDialog(context);
                  await bottomNavigationController.getAstrologerbyId(astrologerId);
                  global.hideLoader();
                  Get.to(() => AstrologerProfile(
                        index: 0,
                      ));
                }
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: CachedNetworkImage(
                      imageUrl: '${global.imgBaseurl}$profileImage',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 48,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        Images.deafultUser,
                        height: 40,
                        width: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        astrologerName,
                        style: Get.theme.primaryTextTheme.headline6!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ).translate(),
                      flagId == 1
                          ? CountdownTimer(
                              endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 300,
                              widgetBuilder: (_, CurrentRemainingTime? time) {
                                if (time == null) {
                                  return Text('00:00', style: TextStyle(fontSize: 10, color: Colors.red));
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: time.min != null ? Text('${time.min}:${time.sec}', style: TextStyle(fontSize: 10, color: Colors.red)) : Text('${time.sec}', style: TextStyle(fontSize: 10, color: Colors.red)),
                                );
                              },
                              onEnd: () async {
                                final ChatController chatController = Get.find<ChatController>();

                                log('in onEnd chat:- ${chatController.isEndChat} :- seconds ${timerController.totalSeconds}');
                                if (chatController.isEndChat == false) {
                                  // call the disconnect method from requested customer
                                  global.showOnlyLoaderDialog(Get.context);
                                  chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                                  chatController.showBottomAcceptChat = false;
                                  global.sp = await SharedPreferences.getInstance();
                                  global.sp!.remove('chatBottom');
                                  global.sp!.setInt('chatBottom', 0);
                                  chatController.chatBottom = false;
                                  chatController.isInchat = false;
                                  chatController.isAstrologerEndedChat = false;
                                  global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                                  chatController.update();
                                  await timerController.endChatTime(timerController.totalSeconds, chatId);
                                  global.hideLoader();
                                  timerController.min = 0;
                                  timerController.minText = "";
                                  timerController.sec = 0;
                                  timerController.secText = "";
                                  timerController.secTimer!.cancel();
                                  timerController.update();
                                  bottomNavigationController.astrologerList.clear();
                                  bottomNavigationController.isAllDataLoaded = false;
                                  if (bottomNavigationController.genderFilterList != null) {
                                    bottomNavigationController.genderFilterList!.clear();
                                  }
                                  if (bottomNavigationController.languageFilter != null) {
                                    bottomNavigationController.languageFilter!.clear();
                                  }
                                  if (bottomNavigationController.skillFilterList != null) {
                                    bottomNavigationController.skillFilterList!.clear();
                                  }
                                  bottomNavigationController.applyFilter = false;
                                  bottomNavigationController.update();
                                  await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                }
                              },
                            )
                          : SizedBox()
                    ],
                  ),
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () async {
                if (flagId == 0) {
                  Get.back();
                } else {
                  TimerController timerController = Get.find<TimerController>();
                  if (chatController.isAstrologerEndedChat != true) {
                    if (timerController.totalSeconds < 60) {
                      Get.dialog(
                        AlertDialog(
                          title: Text(
                            "You can end chat after one minute",
                            style: Get.textTheme.subtitle1,
                          ).translate(),
                          content: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Ok', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                          ),
                        ),
                      );
                    } else {
                      Get.dialog(
                        AlertDialog(
                          title: Text(
                            "Are you sure you want to end chat?",
                            style: Get.textTheme.subtitle1,
                          ).translate(),
                          content: Row(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  global.showOnlyLoaderDialog(context);
                                  final ChatController chatController = Get.find<ChatController>();
                                  chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                                  chatController.showBottomAcceptChat = false;
                                  global.sp = await SharedPreferences.getInstance();
                                  chatController.isEndChat = true;
                                  global.sp!.remove('chatBottom');
                                  global.sp!.setInt('chatBottom', 0);
                                  chatController.chatBottom = false;
                                  chatController.isInchat = false;
                                  chatController.isAstrologerEndedChat = false;
                                  global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                                  chatController.update();
                                  await timerController.endChatTime(timerController.totalSeconds, chatId);
                                  global.hideLoader();
                                  timerController.min = 0;
                                  timerController.minText = "";
                                  timerController.sec = 0;
                                  timerController.secText = "";
                                  timerController.secTimer!.cancel();
                                  timerController.update();
                                  bottomNavigationController.astrologerList.clear();
                                  bottomNavigationController.isAllDataLoaded = false;
                                  if (bottomNavigationController.genderFilterList != null) {
                                    bottomNavigationController.genderFilterList!.clear();
                                  }
                                  if (bottomNavigationController.languageFilter != null) {
                                    bottomNavigationController.languageFilter!.clear();
                                  }
                                  if (bottomNavigationController.skillFilterList != null) {
                                    bottomNavigationController.skillFilterList!.clear();
                                  }
                                  bottomNavigationController.applyFilter = false;
                                  bottomNavigationController.update();
                                  await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                },
                                child: Text('Yes', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('No', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    Get.dialog(
                      AlertDialog(
                        title: Text(
                          "Are you sure you want to end chat?",
                          style: Get.textTheme.subtitle1,
                        ).translate(),
                        content: Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                global.showOnlyLoaderDialog(context);
                                final ChatController chatController = Get.find<ChatController>();
                                chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                                chatController.showBottomAcceptChat = false;
                                global.sp = await SharedPreferences.getInstance();
                                chatController.isEndChat = true;
                                global.sp!.remove('chatBottom');
                                global.sp!.setInt('chatBottom', 0);
                                chatController.chatBottom = false;
                                chatController.isInchat = false;
                                chatController.isAstrologerEndedChat = false;
                                global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                                chatController.update();
                                await timerController.endChatTime(timerController.totalSeconds, chatId);
                                global.hideLoader();
                                timerController.min = 0;
                                timerController.minText = "";
                                timerController.sec = 0;
                                timerController.secText = "";
                                timerController.secTimer!.cancel();
                                timerController.update();
                                bottomNavigationController.astrologerList.clear();
                                bottomNavigationController.isAllDataLoaded = false;
                                if (bottomNavigationController.genderFilterList != null) {
                                  bottomNavigationController.genderFilterList!.clear();
                                }
                                if (bottomNavigationController.languageFilter != null) {
                                  bottomNavigationController.languageFilter!.clear();
                                }
                                if (bottomNavigationController.skillFilterList != null) {
                                  bottomNavigationController.skillFilterList!.clear();
                                }
                                bottomNavigationController.applyFilter = false;
                                bottomNavigationController.update();
                                await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                                Get.back();
                                Get.back();
                                Get.back();
                              },
                              child: Text('Yes', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('No', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            actions: [
              flagId == 0
                  ? IconButton(
                      onPressed: () async {
                        global.showOnlyLoaderDialog(context);
                        await chatController.shareChat(fireBasechatId, astrologerName);
                        global.hideLoader();
                      },
                      icon: Icon(Icons.share))
                  : GetBuilder<TimerController>(builder: (timerController) {
                      if (flagId == 1) {
                        timerController.chatId = chatId;
                        timerController.update();
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (chatController.isAstrologerEndedChat != true) {
                            if (timerController.totalSeconds < 60) {
                              Get.dialog(
                                AlertDialog(
                                  title: Text(
                                    "You can end chat after one minute",
                                    style: Get.textTheme.subtitle1,
                                  ).translate(),
                                  content: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('Ok', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                                  ),
                                ),
                              );
                            } else {
                              Get.dialog(
                                AlertDialog(
                                  title: Text(
                                    "Are you sure you want to end chat?",
                                    style: Get.textTheme.subtitle1,
                                  ).translate(),
                                  content: Row(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          global.showOnlyLoaderDialog(context);
                                          final ChatController chatController = Get.find<ChatController>();
                                          chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                                          chatController.showBottomAcceptChat = false;
                                          global.sp = await SharedPreferences.getInstance();
                                          chatController.isEndChat = true;
                                          global.sp!.remove('chatBottom');
                                          global.sp!.setInt('chatBottom', 0);
                                          chatController.chatBottom = false;
                                          chatController.isInchat = false;
                                          chatController.isAstrologerEndedChat = false;
                                          global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                                          chatController.update();
                                          await timerController.endChatTime(timerController.totalSeconds, chatId);
                                          global.hideLoader();
                                          timerController.min = 0;
                                          timerController.minText = "";
                                          timerController.sec = 0;
                                          timerController.secText = "";
                                          timerController.secTimer!.cancel();
                                          timerController.update();
                                          bottomNavigationController.astrologerList.clear();
                                          bottomNavigationController.isAllDataLoaded = false;
                                          if (bottomNavigationController.genderFilterList != null) {
                                            bottomNavigationController.genderFilterList!.clear();
                                          }
                                          if (bottomNavigationController.languageFilter != null) {
                                            bottomNavigationController.languageFilter!.clear();
                                          }
                                          if (bottomNavigationController.skillFilterList != null) {
                                            bottomNavigationController.skillFilterList!.clear();
                                          }
                                          bottomNavigationController.applyFilter = false;
                                          bottomNavigationController.update();
                                          await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                        },
                                        child: Text('Yes', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('No', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            Get.dialog(
                              AlertDialog(
                                title: Text(
                                  "Are you sure you want to end chat?",
                                  style: Get.textTheme.subtitle1,
                                ).translate(),
                                content: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        global.showOnlyLoaderDialog(context);
                                        final ChatController chatController = Get.find<ChatController>();
                                        chatController.sendMessage('${global.user.name == '' ? 'user' : global.user.name} -> ended chat', fireBasechatId, astrologerId, true);
                                        chatController.showBottomAcceptChat = false;
                                        global.sp = await SharedPreferences.getInstance();
                                        global.sp!.remove('chatBottom');
                                        global.sp!.setInt('chatBottom', 0);
                                        chatController.chatBottom = false;
                                        chatController.isInchat = false;
                                        chatController.isAstrologerEndedChat = false;
                                        chatController.isEndChat = true;
                                        global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                                        chatController.update();
                                        await timerController.endChatTime(timerController.totalSeconds, chatId);
                                        global.hideLoader();
                                        timerController.min = 0;
                                        timerController.minText = "";
                                        timerController.sec = 0;
                                        timerController.secText = "";
                                        timerController.secTimer!.cancel();
                                        timerController.update();
                                        bottomNavigationController.astrologerList = [];
                                        bottomNavigationController.astrologerList.clear();
                                        bottomNavigationController.isAllDataLoaded = false;
                                        if (bottomNavigationController.genderFilterList != null) {
                                          bottomNavigationController.genderFilterList!.clear();
                                        }
                                        if (bottomNavigationController.languageFilter != null) {
                                          bottomNavigationController.languageFilter!.clear();
                                        }
                                        if (bottomNavigationController.skillFilterList != null) {
                                          bottomNavigationController.skillFilterList!.clear();
                                        }
                                        bottomNavigationController.applyFilter = false;
                                        bottomNavigationController.update();
                                        await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                                        Get.back();
                                        Get.back();
                                        Get.back();
                                      },
                                      child: Text('Yes', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('No', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          height: 20,
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color.fromARGB(255, 4, 70, 100), width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'End',
                            style: TextStyle(fontSize: 10),
                          ).translate(),
                        ),
                      );
                    })
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(Images.bgImage),
              ),
            ),
            child: Stack(
              children: [
                GetBuilder<ChatController>(builder: (chatController) {
                  return Column(
                    children: [
                      flagId == 0
                          ? const SizedBox()
                          : FutureBuilder(
                              future: global.translatedText("Warning - Don't close the app without leaving running session."),
                              builder: (context, snapshot) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 5, left: 5),
                                    padding: EdgeInsets.only(top: 3, left: 3, right: 3),
                                    height: 20,
                                    color: Colors.black.withOpacity(0.9),
                                    child: Marquee(
                                      text: snapshot.data ?? "Warning - Don't close the app without leaving running session.",
                                      style: TextStyle(color: Colors.red, fontSize: 10),
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      blankSpace: 20.0,
                                      velocity: 80.0,
                                      pauseAfterRound: Duration(milliseconds: 500),
                                      startPadding: 10.0,
                                      accelerationDuration: Duration(milliseconds: 500),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration: Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    ));
                              }),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: chatController.getChatMessages(fireBasechatId, global.currentUserId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState.name == "waiting") {
                                return Center(child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Text('snapShotError :- ${snapshot.error}');
                                } else {
                                  List<ChatMessageModel> messageList = [];
                                  for (var res in snapshot.data!.docs) {
                                    messageList.add(ChatMessageModel.fromJson(res.data()));
                                  }
                                  print(messageList.length);
                                  return ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 50),
                                      itemCount: messageList.length,
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        ChatMessageModel message = messageList[index];
                                        chatController.isMe = message.userId1 == '${global.currentUserId}';
                                        return messageList[index].isEndMessage == true
                                            ? Container(
                                                margin: const EdgeInsets.only(bottom: 10),
                                                color: const Color.fromARGB(255, 247, 244, 211),
                                                padding: const EdgeInsets.all(8),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  messageList[index].message!,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment: chatController.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: chatController.isMe ? Colors.grey[300] : Get.theme.primaryColor,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: const Radius.circular(12),
                                                        topRight: const Radius.circular(12),
                                                        bottomLeft: chatController.isMe ? const Radius.circular(0) : const Radius.circular(12),
                                                        bottomRight: chatController.isMe ? const Radius.circular(0) : const Radius.circular(12),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                                    child: Column(
                                                      crossAxisAlignment: chatController.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          constraints: BoxConstraints(maxWidth: Get.width - 100),
                                                          child: Text(
                                                            messageList[index].message!,
                                                            style: const TextStyle(
                                                              color: Colors.black,
                                                            ),
                                                            textAlign: chatController.isMe ? TextAlign.end : TextAlign.start,
                                                          ),
                                                        ),
                                                        messageList[index].createdAt != null
                                                            ? Padding(
                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text(DateFormat().add_jm().format(messageList[index].createdAt!),
                                                                        style: const TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 9.5,
                                                                        )),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                      });
                                }
                              }
                            }),
                      ),
                    ],
                  );
                }),
                flagId == 2
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: flagId == 0
                            ? GestureDetector(
                                onTap: () {
                                  Get.dialog(AlertDialog(
                                      scrollable: true,
                                      title: Container(
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Icon(Icons.close),
                                            )),
                                      ),
                                      titlePadding: const EdgeInsets.all(0),
                                      content: addReviewWidget(astrologerName, "astrologerProfile", context)));
                                },
                                child: GetBuilder<ChatController>(builder: (chatController) {
                                  return Card(
                                    elevation: 1,
                                    child: Container(
                                      width: Get.width,
                                      color: Color.fromARGB(255, 228, 224, 193),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Add Your Review').translate(),
                                            chatController.reviewData.isEmpty
                                                ? const SizedBox()
                                                : Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              chatController.reviewData[0].isPublic == 0
                                                                  ? CircleAvatar(
                                                                      radius: 22,
                                                                      child: CircleAvatar(
                                                                        backgroundColor: Colors.white,
                                                                        backgroundImage: AssetImage(Images.deafultUser),
                                                                      ),
                                                                    )
                                                                  : splashController.currentUser?.profile == ""
                                                                      ? CircleAvatar(
                                                                          radius: 22,
                                                                          child: CircleAvatar(
                                                                            backgroundColor: Colors.white,
                                                                            backgroundImage: AssetImage(Images.deafultUser),
                                                                          ),
                                                                        )
                                                                      : CachedNetworkImage(
                                                                          imageUrl: "${global.imgBaseurl}${splashController.currentUser?.profile}",
                                                                          imageBuilder: (context, imageProvider) {
                                                                            return CircleAvatar(
                                                                              radius: 22,
                                                                              backgroundColor: Colors.white,
                                                                              backgroundImage: NetworkImage("${global.imgBaseurl}${splashController.currentUser?.profile}"),
                                                                            );
                                                                          },
                                                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) {
                                                                            return CircleAvatar(
                                                                                radius: 22,
                                                                                backgroundColor: Colors.white,
                                                                                child: Image.asset(
                                                                                  Images.deafultUser,
                                                                                  fit: BoxFit.fill,
                                                                                  height: 50,
                                                                                ));
                                                                          },
                                                                        ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(chatController.reviewData[0].isPublic == 0 ? 'Anonymous' : splashController.currentUser!.name ?? 'User').translate(),
                                                                  RatingBar(
                                                                    initialRating: chatController.reviewData[0].rating,
                                                                    itemCount: 5,
                                                                    allowHalfRating: true,
                                                                    itemSize: 15,
                                                                    ignoreGestures: true,
                                                                    ratingWidget: RatingWidget(
                                                                      full: const Icon(Icons.grade, color: Colors.yellow),
                                                                      half: const Icon(Icons.star_half, color: Colors.yellow),
                                                                      empty: const Icon(Icons.grade, color: Colors.grey),
                                                                    ),
                                                                    onRatingUpdate: (rating) {},
                                                                  ),
                                                                  chatController.reviewData[0].review != "" ? Text(chatController.reviewData[0].review) : const SizedBox(),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          PopupMenuButton(
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color: Colors.grey,
                                                            ),
                                                            itemBuilder: (context) => [
                                                              PopupMenuItem(
                                                                child: Text('Edit review').translate(),
                                                                value: "Edit",
                                                              ),
                                                              PopupMenuItem(
                                                                value: "delete",
                                                                child: Text(
                                                                  'Delete Review',
                                                                  style: Get.textTheme.subtitle1!.copyWith(color: Colors.red),
                                                                ).translate(),
                                                              )
                                                            ],
                                                            onSelected: (value) async {
                                                              if (value == "Edit") {
                                                                Get.dialog(AlertDialog(
                                                                  scrollable: true,
                                                                  content: addReviewWidget(astrologerName, profileImage, context),
                                                                ));
                                                              } else if (value == "delete") {
                                                                global.showOnlyLoaderDialog(context);
                                                                await chatController.deleteReview(chatController.reviewData[0].id!);
                                                                await chatController.getuserReview(astrologerId);
                                                                global.hideLoader();
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                child: GetBuilder<ChatController>(builder: (chatController) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                          ),
                                          height: 50,
                                          child: TextField(
                                            controller: messageController,
                                            onChanged: (value) {},
                                            cursorColor: Colors.black,
                                            style: TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                borderSide: BorderSide(color: Get.theme.primaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                borderSide: BorderSide(color: Get.theme.primaryColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Material(
                                          elevation: 3,
                                          color: Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          child: Container(
                                            height: 49,
                                            width: 49,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Get.theme.primaryColor,
                                              ),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                if (messageController.text != "") {
                                                  chatController.sendMessage(messageController.text, fireBasechatId, astrologerId, false);
                                                  messageController.clear();
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(left: 5.0),
                                                child: Icon(
                                                  Icons.send,
                                                  size: 25,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addReviewWidget(String astrologerName, String astrologerProfile, BuildContext context) {
    SplashController splashController = Get.find<SplashController>();
    return GetBuilder<ChatController>(builder: (chatController) {
      return SizedBox(
        height: Get.height * 0.6,
        child: Column(
          children: [
            Center(child: Text(astrologerName).translate()),
            profileImage == ""
                ? Center(
                    child: CircleAvatar(
                      radius: 33,
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            Images.deafultUser,
                            fit: BoxFit.fill,
                            height: 40,
                          )),
                    ),
                  )
                : Center(
                    child: CachedNetworkImage(
                      imageUrl: "${global.imgBaseurl}$profileImage",
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              Images.deafultUser,
                              fit: BoxFit.fill,
                              height: 40,
                            ));
                      },
                    ),
                  ),
            Row(
              children: [
                !chatController.isPublic
                    ? splashController.currentUser?.profile == ""
                        ? CircleAvatar(
                            radius: 22,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(Images.deafultUser),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: "${global.imgBaseurl}${splashController.currentUser?.profile}",
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage("${global.imgBaseurl}${splashController.currentUser?.profile}"),
                              );
                            },
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) {
                              return CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    Images.deafultUser,
                                    fit: BoxFit.fill,
                                    height: 50,
                                  ));
                            },
                          )
                    : CircleAvatar(
                        radius: 22,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(Images.deafultUser),
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                !chatController.isPublic ? Text(splashController.currentUser!.name ?? "Anonymous").translate() : Text("Anonymous").translate(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: chatController.isPublic,
                    activeColor: Get.theme.primaryColor,
                    onChanged: (bool? value) {
                      chatController.isPublic = value!;
                      chatController.update();
                    }),
                SizedBox(
                  width: Get.width * 0.5,
                  child: Text('Hide my name from all public reviews',
                      style: Get.textTheme.subtitle1!.copyWith(
                        fontSize: 12,
                      )).translate(),
                )
              ],
            ),
            Center(
              child: RatingBar(
                initialRating: chatController.rating ?? 0,
                itemCount: 5,
                allowHalfRating: true,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.grade, color: Colors.yellow),
                  half: const Icon(Icons.star_half, color: Colors.yellow),
                  empty: const Icon(Icons.grade, color: Colors.grey),
                ),
                onRatingUpdate: (rating) {
                  chatController.rating = rating;
                  chatController.update();
                },
              ),
            ),
            FutureBuilder(
                future: global.translatedText('Describe your experience(optional)'),
                builder: (context, snapshot) {
                  return TextField(
                    controller: chatController.reviewController,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 2,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(fontSize: 12),
                      hintText: snapshot.data ?? "Describe your experience(optional)",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    print('submit');
                    if (chatController.rating == 0) {
                      global.showToast(
                        message: 'Rate Astrologer',
                        textColor: global.textColor,
                        bgColor: global.toastBackGoundColor,
                      );
                    } else if (chatController.reviewController.text == "") {
                      global.showToast(
                        message: 'Enter Review',
                        textColor: global.textColor,
                        bgColor: global.toastBackGoundColor,
                      );
                    } else {
                      if (chatController.reviewData.isNotEmpty) {
                        global.showOnlyLoaderDialog(context);
                        await chatController.updateReview(chatController.reviewData[0].id!, astrologerId);
                        global.hideLoader();
                      } else {
                        global.showOnlyLoaderDialog(context);
                        await chatController.addReview(astrologerId);
                        global.hideLoader();
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: Get.theme.primaryTextTheme.subtitle1!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ).translate(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
