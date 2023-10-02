import 'package:AstroGuru/controllers/chatController.dart';
import 'package:AstroGuru/utils/images.dart';
import 'package:AstroGuru/views/chat/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import '../../controllers/bottomNavigationController.dart';
import '../../controllers/timer_controller.dart';
import '../bottomNavigationBarScreen.dart';

class IncomingChatRequest extends StatelessWidget {
  final String? profile;
  final String? astrologerName;
  final String fireBasechatId;
  final int astrologerId;
  final int chatId;
  final String? fcmToken;
  IncomingChatRequest({
    super.key,
    this.profile,
    this.astrologerName,
    required this.fireBasechatId,
    required this.astrologerId,
    required this.chatId,
    this.fcmToken,
  });
  final ChatController chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Incoming chat request from",
                style: Get.textTheme.bodyText1,
              ).translate(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Get.theme.primaryColor,
                    backgroundImage: AssetImage('assets/images/splash.png'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${global.getSystemFlagValue(global.systemFlagNameList.appName)}',
                    style: Get.textTheme.headline5,
                  ).translate(),
                ],
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: profile == ""
                    ? Image.asset(
                        Images.deafultUser,
                        fit: BoxFit.fill,
                        height: 50,
                        width: 40,
                      )
                    : CachedNetworkImage(
                        imageUrl: '${global.imgBaseurl}$profile',
                        imageBuilder: (context, imageProvider) => CircleAvatar(radius: 48, backgroundImage: imageProvider),
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          Images.deafultUser,
                          fit: BoxFit.fill,
                          height: 50,
                          width: 40,
                        ),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                astrologerName == "" ? 'Astrologer' : astrologerName ?? "",
                style: Get.textTheme.headline5,
              ).translate(),
            ],
          ),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await chatController.acceptedChat(chatId);
                  global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'Start simple chat timer');
                  chatController.isInchat = true;
                  chatController.isEndChat = false;
                  TimerController timerController = Get.find<TimerController>();
                  timerController.startTimer();
                  chatController.update();
                  Get.to(() => AcceptChatScreen(
                        flagId: 1,
                        astrologerName: astrologerName ?? "Astrologer",
                        profileImage: '$profile',
                        fireBasechatId: fireBasechatId,
                        astrologerId: astrologerId,
                        chatId: chatId,
                        fcmToken: fcmToken,
                      ));
                },
                icon: Icon(Icons.chat),
                label: Text("Start chat").translate(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  global.showOnlyLoaderDialog(context);
                  await chatController.rejectedChat(chatId);
                  global.hideLoader();
                  global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from customer');
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(0, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 0,
                      ));
                },
                child: Text(
                  "Reject Chat Request",
                  style: Get.textTheme.bodyText2!.copyWith(color: Colors.red, fontSize: 12),
                ).translate(),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
