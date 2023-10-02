// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:AstroGuru/controllers/astrologyBlogController.dart';
import 'package:AstroGuru/controllers/astromallController.dart';
import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/dailyHoroscopeController.dart';
import 'package:AstroGuru/controllers/history_controller.dart';
import 'package:AstroGuru/controllers/homeController.dart';
import 'package:AstroGuru/controllers/kundliController.dart';
import 'package:AstroGuru/controllers/liveController.dart';
import 'package:AstroGuru/controllers/reviewController.dart';

import 'package:AstroGuru/model/kundli_model.dart';
import 'package:AstroGuru/utils/date_converter.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:AstroGuru/utils/images.dart';
import 'package:AstroGuru/views/addMoneyToWallet.dart';
import 'package:AstroGuru/views/astroBlog/astrologyBlogListScreen.dart';
import 'package:AstroGuru/views/astroBlog/astrologyDetailScreen.dart';
import 'package:AstroGuru/views/astrologerNews.dart';
import 'package:AstroGuru/views/astrologerProfile/astrologerProfile.dart';
import 'package:AstroGuru/views/astrologerVideo.dart';
import 'package:AstroGuru/views/astromall/astromallScreen.dart';
import 'package:AstroGuru/views/blog_screen.dart';
import 'package:AstroGuru/views/call/call_history_detail_screen.dart';
import 'package:AstroGuru/views/chat/chat_screen.dart';
import 'package:AstroGuru/views/clientsReviewScreem.dart';
import 'package:AstroGuru/views/customer_support/customerSupportChatScreen.dart';
import 'package:AstroGuru/views/daily_horoscope/dailyHoroscopeScreen.dart';
import 'package:AstroGuru/views/kudali/kundliScreen.dart';
import 'package:AstroGuru/views/kundliMatching/kundliMatchingScreen.dart';
import 'package:AstroGuru/views/liveAstrologerList.dart';
import 'package:AstroGuru/views/live_astrologer/live_astrologer_screen.dart';
import 'package:AstroGuru/views/panchangScreen.dart';
import 'package:AstroGuru/views/searchAstrologerScreen.dart';
import 'package:AstroGuru/widget/drawerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../controllers/IntakeController.dart';
import '../controllers/astrologer_assistant_controller.dart';
import '../controllers/chatController.dart';
import '../controllers/customer_support_controller.dart';
import '../controllers/splashController.dart';
import '../controllers/walletController.dart';
import 'astromall/astroProductScreen.dart';

class HomeScreen extends StatelessWidget {
  final KundliModel? userDetails;
  HomeScreen({a, o, this.userDetails}) : super();
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final HomeController homeController = Get.find<HomeController>();
  BottomNavigationController bottomControllerMain = Get.find<BottomNavigationController>();
  LiveController liveController = Get.find<LiveController>();
  KundliController kundliController = Get.find<KundliController>();
  SplashController splashController = Get.find<SplashController>();
  final WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isExit = await homeController.onBackPressed();
        if (isExit) {
          exit(0);
        }
        return isExit;
      },
      child: Scaffold(
        key: drawerKey,
        drawer: DrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
            style: Get.theme.primaryTextTheme.headline6!.copyWith(fontWeight: FontWeight.normal),
          ).translate(),
          iconTheme: IconThemeData(
            color: Get.theme.iconTheme.color,
          ),
          actions: [
            InkWell(
              onTap: () async {
                bool isLogin = await global.isLogin();
                global.showOnlyLoaderDialog(context);
                await walletController.getAmount();
                global.hideLoader();
                if (isLogin) {
                  Get.to(() => AddmoneyToWallet());
                }
              },
              child: Image.asset(
                Images.wallet,
                height: 25,
                width: 25,
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () async {
                homeController.lan = [];
                await homeController.getLanguages();
                await homeController.updateLanIndex();
                print(homeController.lan);
                global.checkBody().then((result) {
                  if (result) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return GetBuilder<HomeController>(builder: (h) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: GetBuilder<HomeController>(builder: (h) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () => Get.back(),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: const Icon(Icons.close),
                                        )),
                                    Container(
                                        padding: EdgeInsets.all(6),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          Text('Choose your app language', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                                          GetBuilder<HomeController>(builder: (home) {
                                            return Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: Wrap(
                                                  children: List.generate(homeController.lan.length, (index) {
                                                return InkWell(
                                                  onTap: () {
                                                    homeController.updateLan(index);
                                                  },
                                                  child: GetBuilder<HomeController>(builder: (h) {
                                                    return Container(
                                                      height: 80,
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.only(left: 7, right: 7, top: 10),
                                                      width: 75,
                                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: homeController.lan[index].isSelected ? Color.fromARGB(255, 228, 217, 185) : Colors.transparent,
                                                        border: Border.all(color: homeController.lan[index].isSelected ? Get.theme.primaryColor : Colors.black),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                        Text(
                                                          homeController.lan[index].title,
                                                          style: Get.textTheme.bodyText2,
                                                        ),
                                                        Text(
                                                          homeController.lan[index].subTitle,
                                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 12),
                                                        )
                                                      ]),
                                                    );
                                                  }),
                                                );
                                              })),
                                            );
                                          }),
                                          Container(
                                            margin: EdgeInsets.only(top: 25),
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                splashController.currentLanguageCode = homeController.lan[homeController.selectedIndex].lanCode;
                                                splashController.update();
                                                global.sp = await SharedPreferences.getInstance();
                                                global.sp!.setString('currentLanguage', splashController.currentLanguageCode);
                                                BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                                bottomNavigationController.isValueShowChat = false;
                                                bottomNavigationController.isValueShow = false;
                                                bottomNavigationController.isValueShowLive = false;
                                                bottomNavigationController.isValueShowCall = false;
                                                bottomNavigationController.isValueShowHist = false;
                                                bottomNavigationController.update();
                                                // ignore: invalid_use_of_protected_member
                                                bottomNavigationController.refresh();
                                                Get.back();
                                              },
                                              child: Text('APPLY', style: Get.textTheme.bodyText1).translate(),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                              ),
                                            ),
                                          )
                                        ]))
                                  ],
                                );
                              }),
                            );
                          });
                        });
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  Images.translation,
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () async {
                bool isLogin = await global.isLogin();
                if (isLogin) {
                  CustomerSupportController customerSupportController = Get.find<CustomerSupportController>();
                  AstrologerAssistantController astrologerAssistantController = Get.find<AstrologerAssistantController>();
                  global.showOnlyLoaderDialog(context);
                  await customerSupportController.getCustomerTickets();
                  await astrologerAssistantController.getChatWithAstrologerAssisteant();
                  global.hideLoader();
                  Get.to(() => CustomerSupportChat());
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  Images.customerService,
                  height: 25,
                  width: 25,
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await homeController.getBanner();
            await homeController.getBlog();
            await homeController.getAstroNews();
            await homeController.getMyOrder();
            await homeController.getAstrologyVideos();
            await homeController.getClientsTestimonals();
            await bottomControllerMain.getLiveAstrologerList();
          },
          child: GetBuilder<BottomNavigationController>(builder: (bottomController) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => SearchAstrologerScreen());
                          },
                          child: SizedBox(
                            height: 42,
                            child: Card(
                              borderOnForeground: false,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 20,
                                      color: Colors.grey[350],
                                    ),
                                    Text(
                                      'Search astrologers, astromall products',
                                      style: Get.theme.primaryTextTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black38,
                                      ),
                                    ).translate()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Get.find<DailyHoroscopeController>().selectZodic(0);
                                      await Get.find<DailyHoroscopeController>().getHoroscopeList(horoscopeId: Get.find<DailyHoroscopeController>().signId);
                                      Get.to(() => DailyHoroscopeScreen());
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.transparent,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.dailyHoroscope)}',
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Daily\nHoroscope',
                                      textAlign: TextAlign.center,
                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                        height: 1,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                      ),
                                    ).translate(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GetBuilder<KundliController>(builder: (kundliController) {
                                    return GestureDetector(
                                        onTap: () async {
                                          bool isLogin = await global.isLogin();
                                          if (isLogin) {
                                            global.showOnlyLoaderDialog(Get.context);
                                            await kundliController.getKundliList();
                                            global.hideLoader();
                                            Get.to(() => KundaliScreen());
                                          }
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Colors.transparent,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.freeKundli)}',
                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
                                          ),
                                        ));
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Free\nKundali',
                                      textAlign: TextAlign.center,
                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                        height: 1,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                      ),
                                    ).translate(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GetBuilder<KundliController>(builder: (kundliController) {
                                    return GestureDetector(
                                        onTap: () async {
                                          global.showOnlyLoaderDialog(Get.context);
                                          await kundliController.getKundliList();
                                          global.hideLoader();
                                          Get.to(() => KundliMatchingScreen());
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Colors.transparent,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.kundliMatching)}',
                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
                                          ),
                                        ));
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Kundali\nMatching',
                                      textAlign: TextAlign.center,
                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                        height: 1,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                      ),
                                    ).translate(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final AstromallController astromallController = Get.find<AstromallController>();
                                      astromallController.astroCategory.clear();
                                      astromallController.isAllDataLoaded = false;
                                      astromallController.update();
                                      global.showOnlyLoaderDialog(context);
                                      await astromallController.getAstromallCategory(false);
                                      global.hideLoader();
                                      Get.to(() => AstromallScreen());
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.transparent,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.astromall)}',
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Astromall\n ',
                                      textAlign: TextAlign.center,
                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                        height: 1,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                      ),
                                    ).translate(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return homeController.bannerList.isEmpty
                            ? const SizedBox()
                            : ImageSlideshow(
                                isLoop: true,
                                autoPlayInterval: 3000,
                                width: double.infinity,
                                height: 150,
                                initialPage: 0,
                                children: List.generate(
                                  homeController.bannerList.length,
                                  (index) => GestureDetector(
                                    onTap: () async {
                                      if (homeController.bannerList[index].bannerType == 'Astrologer') {
                                        global.showOnlyLoaderDialog(context);
                                        bottomController.astrologerList = [];
                                        bottomController.astrologerList.clear();
                                        bottomController.isAllDataLoaded = false;
                                        bottomController.update();
                                        await bottomController.getAstrologerList(isLazyLoading: false);
                                        global.hideLoader();
                                        bottomController.setBottomIndex(1, 0);
                                      } else if (homeController.bannerList[index].bannerType == 'Astromall') {
                                        final AstromallController astromallController = Get.find<AstromallController>();
                                        astromallController.astroCategory.clear();
                                        astromallController.isAllDataLoaded = false;
                                        astromallController.update();
                                        global.showOnlyLoaderDialog(context);
                                        await astromallController.getAstromallCategory(false);
                                        global.hideLoader();
                                        Get.to(() => AstromallScreen());
                                      } else {}
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: '${global.imgBaseurl}${homeController.bannerList[index].bannerImage}',
                                      imageBuilder: (context, imageProvider) {
                                        return homeController.checkBannerValid(
                                          startDate: homeController.bannerList[index].fromDate,
                                          endDate: homeController.bannerList[index].toDate,
                                        )
                                            ? Card(
                                                child: Container(
                                                  height: Get.height * 0.2,
                                                  width: Get.width,
                                                  margin: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: imageProvider,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox();
                                      },
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Card(
                                        child: Image.asset(
                                          Images.blog,
                                          height: Get.height * 0.15,
                                          width: Get.width,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return homeController.myOrders.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: 200,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'My orders',
                                                    style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                                  ).translate(),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  final HistoryController historyController = Get.find<HistoryController>();
                                                  global.showOnlyLoaderDialog(context);
                                                  await historyController.getPaymentLogs(global.currentUserId!, false);
                                                  historyController.walletTransactionList = [];
                                                  historyController.walletTransactionList.clear();
                                                  historyController.walletAllDataLoaded = false;
                                                  historyController.update();
                                                  await historyController.getWalletTransaction(global.currentUserId!, false);
                                                  historyController.astroMallHistoryList = [];
                                                  historyController.astroMallHistoryList.clear();
                                                  historyController.isAllDataLoaded = false;
                                                  historyController.update();
                                                  await historyController.getAstroMall(global.currentUserId!, false);
                                                  historyController.callHistoryList = [];
                                                  historyController.callHistoryList.clear();
                                                  historyController.callAllDataLoaded = false;
                                                  historyController.update();
                                                  await historyController.getCallHistory(global.currentUserId!, false);
                                                  historyController.chatHistoryList = [];
                                                  historyController.chatHistoryList.clear();
                                                  historyController.chatAllDataLoaded = false;
                                                  historyController.update();
                                                  await historyController.getChatHistory(global.currentUserId!, false);
                                                  global.hideLoader();
                                                  bottomController.setBottomIndex(4, 0);
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GetBuilder<HomeController>(
                                          builder: (c) {
                                            return Expanded(
                                              child: ListView.builder(
                                                itemCount: homeController.myOrders.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.only(top: 10, left: 10),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                                        ReviewController reviewController = Get.find<ReviewController>();
                                                        global.showOnlyLoaderDialog(context);
                                                        await reviewController.getReviewData(homeController.myOrders[index].astrologerId ?? 0);
                                                        await bottomNavigationController.getAstrologerbyId(homeController.myOrders[index].astrologerId ?? 0);
                                                        global.hideLoader();
                                                        if (bottomNavigationController.astrologerbyId.isNotEmpty) {
                                                          Get.to(() => AstrologerProfile(
                                                                index: index,
                                                              ));
                                                        }
                                                      },
                                                      child: Card(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 65,
                                                              width: 65,
                                                              margin: const EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Get.theme.primaryColor),
                                                                borderRadius: BorderRadius.circular(7),
                                                              ),
                                                              child: CircleAvatar(
                                                                radius: 35,
                                                                backgroundColor: Colors.white,
                                                                child: homeController.myOrders[index].profileImage == ""
                                                                    ? Image.asset(
                                                                        Images.deafultUser,
                                                                        fit: BoxFit.cover,
                                                                        height: 50,
                                                                        width: 40,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl: '${global.imgBaseurl}${homeController.myOrders[index].profileImage}',
                                                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                        errorWidget: (context, url, error) => Image.asset(
                                                                          Images.deafultUser,
                                                                          fit: BoxFit.cover,
                                                                          height: 50,
                                                                          width: 40,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('${homeController.myOrders[index].astrologerName}').translate(),
                                                                  Text(
                                                                    DateConverter.dateTimeStringToDateOnly(homeController.myOrders[index].createdAt.toString()),
                                                                    style: TextStyle(color: Colors.grey, fontSize: 10),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          if (homeController.myOrders[index].orderType == "call") {
                                                                            if (homeController.myOrders[index].callId != 0) {
                                                                              IntakeController intakeController = Get.find<IntakeController>();
                                                                              HistoryController historyController = Get.find<HistoryController>();
                                                                              global.showOnlyLoaderDialog(context);
                                                                              await intakeController.getFormIntakeData();
                                                                              await historyController.getCallHistoryById(homeController.myOrders[index].callId!);
                                                                              global.hideLoader();
                                                                              Get.to(() => CallHistoryDetailScreen(
                                                                                    astrologerId: homeController.myOrders[index].astrologerId!,
                                                                                    astrologerProfile: "",
                                                                                    index: index,
                                                                                  ));
                                                                            }
                                                                          } else if (homeController.myOrders[index].orderType == "chat") {
                                                                            if (homeController.myOrders[index].firebaseChatId != "") {
                                                                              ChatController chatController = Get.find<ChatController>();
                                                                              global.showOnlyLoaderDialog(context);
                                                                              await chatController.getuserReview(homeController.myOrders[index].astrologerId!);
                                                                              global.hideLoader();
                                                                              Get.to(() => AcceptChatScreen(
                                                                                    flagId: 0,
                                                                                    profileImage: homeController.myOrders[index].profileImage ?? "",
                                                                                    astrologerName: homeController.myOrders[index].astrologerName ?? "Astrologer",
                                                                                    fireBasechatId: homeController.myOrders[index].firebaseChatId!,
                                                                                    astrologerId: homeController.myOrders[index].astrologerId!,
                                                                                    chatId: homeController.myOrders[index].id!,
                                                                                  ));
                                                                            }
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(color: Get.theme.primaryColor),
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            child: homeController.myOrders[index].orderType == "call"
                                                                                ? Row(
                                                                                    children: [
                                                                                      Icon(Icons.play_arrow),
                                                                                      Image.asset(
                                                                                        'assets/images/voice.png',
                                                                                        height: 40,
                                                                                        width: 50,
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : homeController.myOrders[index].orderType == "chat"
                                                                                    ? Padding(
                                                                                        padding: const EdgeInsets.all(10.0),
                                                                                        child: Text('View Chat').translate(),
                                                                                      )
                                                                                    : const SizedBox()),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          global.showOnlyLoaderDialog(context);
                                                                          final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                                                          Get.find<ReviewController>().getReviewData(homeController.myOrders[index].astrologerId ?? 0);
                                                                          await bottomNavigationController.getAstrologerbyId(homeController.myOrders[index].astrologerId ?? 0);
                                                                          global.hideLoader();
                                                                          if (bottomNavigationController.astrologerbyId.isNotEmpty) {
                                                                            Get.to(() => AstrologerProfile(
                                                                                  index: index,
                                                                                ));
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                            padding: const EdgeInsets.all(10),
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(color: Get.theme.primaryColor),
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            child: Text(homeController.myOrders[index].orderType == "call" ? 'Call Again' : 'Chat again').translate()),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<BottomNavigationController>(builder: (c) {
                        return Get.find<BottomNavigationController>().liveAstrologer.length == 0
                            ? const SizedBox()
                            : SizedBox(
                                height: 200,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Live Astrologers',
                                                    style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                                  ).translate(),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        global.showOnlyLoaderDialog(context);
                                                        await bottomControllerMain.getLiveAstrologerList();
                                                        global.hideLoader();
                                                      },
                                                      child: Icon(
                                                        Icons.refresh,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  Get.to(() => LiveAstrologerListScreen());
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GetBuilder<BottomNavigationController>(
                                          builder: (c) {
                                            return Expanded(
                                              child: ListView.builder(
                                                itemCount: Get.find<BottomNavigationController>().liveAstrologer.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.only(top: 10, left: 10),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        bottomControllerMain.anotherLiveAstrologers = Get.find<BottomNavigationController>().liveAstrologer.where((element) => element.astrologerId != Get.find<BottomNavigationController>().liveAstrologer[index].astrologerId).toList();
                                                        bottomControllerMain.update();
                                                        await liveController.getWaitList(Get.find<BottomNavigationController>().liveAstrologer[index].channelName);
                                                        int index2 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
                                                        if (index2 != -1) {
                                                          liveController.isImInWaitList = true;
                                                          liveController.update();
                                                        } else {
                                                          liveController.isImInWaitList = false;
                                                          liveController.update();
                                                        }
                                                        liveController.isImInLive = true;
                                                        liveController.isJoinAsChat = false;
                                                        liveController.isLeaveCalled = false;
                                                        liveController.update();
                                                        bool isLogin = await global.isLogin();
                                                        if (isLogin) {
                                                          Get.to(
                                                            () => LiveAstrologerScreen(
                                                              token: Get.find<BottomNavigationController>().liveAstrologer[index].token,
                                                              channel: Get.find<BottomNavigationController>().liveAstrologer[index].channelName,
                                                              astrologerName: Get.find<BottomNavigationController>().liveAstrologer[index].name,
                                                              astrologerProfile: Get.find<BottomNavigationController>().liveAstrologer[index].profileImage,
                                                              astrologerId: Get.find<BottomNavigationController>().liveAstrologer[index].astrologerId,
                                                              isFromHome: true,
                                                              charge: Get.find<BottomNavigationController>().liveAstrologer[index].charge,
                                                              isForLiveCallAcceptDecline: false,
                                                              isFromNotJoined: false,
                                                              isFollow: Get.find<BottomNavigationController>().liveAstrologer[index].isFollow!,
                                                              videoCallCharge: Get.find<BottomNavigationController>().liveAstrologer[index].videoCallRate,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: SizedBox(
                                                          child: Stack(alignment: Alignment.bottomCenter, children: [
                                                        Get.find<BottomNavigationController>().liveAstrologer[index].profileImage != ""
                                                            ? Container(
                                                                width: 95,
                                                                height: 200,
                                                                margin: EdgeInsets.only(right: 4),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.black.withOpacity(0.3),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border: Border.all(
                                                                      color: Color.fromARGB(255, 214, 214, 214),
                                                                    ),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: NetworkImage(
                                                                          '${global.imgBaseurl}${Get.find<BottomNavigationController>().liveAstrologer[index].profileImage}',
                                                                        ),
                                                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))),
                                                              )
                                                            : Container(
                                                                width: 95,
                                                                height: 200,
                                                                margin: EdgeInsets.only(right: 4),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.black.withOpacity(0.3),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border: Border.all(
                                                                      color: Color.fromARGB(255, 214, 214, 214),
                                                                    ),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: AssetImage(
                                                                          Images.deafultUser,
                                                                        ),
                                                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))),
                                                              ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 20),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                color: Get.theme.primaryColor,
                                                                borderRadius: BorderRadius.circular(5),
                                                              )),
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 20),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Get.theme.primaryColor,
                                                                        borderRadius: BorderRadius.circular(5),
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(horizontal: 3),
                                                                      child: Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius: 3,
                                                                            backgroundColor: Colors.green,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 3,
                                                                          ),
                                                                          Text(
                                                                            'LIVE',
                                                                            style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w300,
                                                                            ),
                                                                          ).translate(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${Get.find<BottomNavigationController>().liveAstrologer[index].name}',
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ).translate(),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ])));
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                        return bottomNavigationController.astrologerList.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: 238,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Astrologers',
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              GestureDetector(
                                                onTap: () {
                                                  bottomController.bottomNavIndex = 1;
                                                  bottomController.update();
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: bottomNavigationController.astrologerList.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                Get.find<ReviewController>().getReviewData(bottomNavigationController.astrologerList[index].id!);
                                                global.showOnlyLoaderDialog(context);
                                                await bottomNavigationController.getAstrologerbyId(bottomNavigationController.astrologerList[index].id!);
                                                global.hideLoader();
                                                Get.to(() => AstrologerProfile(
                                                      index: index,
                                                    ));
                                              },
                                              child: Card(
                                                elevation: 4,
                                                margin: EdgeInsets.only(right: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 10),
                                                        child: Container(
                                                          height: 75,
                                                          decoration: BoxDecoration(border: Border.all(color: Get.theme.primaryColor), borderRadius: BorderRadius.circular(7)),
                                                          child: CircleAvatar(
                                                            radius: 35,
                                                            backgroundColor: Colors.white,
                                                            child: CachedNetworkImage(
                                                              imageUrl: '${global.imgBaseurl}${bottomNavigationController.astrologerList[index].profileImage}',
                                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                              errorWidget: (context, url, error) => Image.asset(
                                                                Images.deafultUser,
                                                                fit: BoxFit.cover,
                                                                height: 50,
                                                                width: 40,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        bottomNavigationController.astrologerList[index].name!,
                                                        textAlign: TextAlign.center,
                                                        style: Get.theme.textTheme.subtitle1!.copyWith(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          letterSpacing: 0,
                                                        ),
                                                      ).translate(),
                                                      Text(
                                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].charge}/min',
                                                        textAlign: TextAlign.center,
                                                        style: Get.theme.textTheme.subtitle1!.copyWith(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w300,
                                                          letterSpacing: 0,
                                                        ),
                                                      ).translate(),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6).copyWith(top: 5),
                                                        child: SizedBox(
                                                          height: 30,
                                                          child: TextButton(
                                                            style: ButtonStyle(
                                                              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                                              fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                                              backgroundColor: MaterialStateProperty.all(Colors.white),
                                                              shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  side: BorderSide(
                                                                    color: Colors.green,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () async {
                                                              Get.find<ReviewController>().getReviewData(bottomNavigationController.astrologerList[index].id!);
                                                              global.showOnlyLoaderDialog(context);
                                                              await bottomNavigationController.getAstrologerbyId(bottomNavigationController.astrologerList[index].id!);
                                                              global.hideLoader();
                                                              await Get.to(() => AstrologerProfile(
                                                                    index: index,
                                                                  ));
                                                            },
                                                            child: Text(
                                                              'Connect',
                                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.green),
                                                            ).translate(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return homeController.blogList.length == 0
                            ? SizedBox()
                            : SizedBox(
                                height: 250,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Latest from blog',
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              GestureDetector(
                                                onTap: () async {
                                                  BlogController blogController = Get.find<BlogController>();
                                                  global.showOnlyLoaderDialog(context);
                                                  blogController.astrologyBlogs = [];
                                                  blogController.astrologyBlogs.clear();
                                                  blogController.isAllDataLoaded = false;
                                                  blogController.update();
                                                  await blogController.getAstrologyBlog("", false);
                                                  global.hideLoader();
                                                  Get.to(() => AstrologyBlogScreen());
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: GetBuilder<HomeController>(builder: (homeControllerr) {
                                          return ListView.builder(
                                            itemCount: homeController.blogList.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  global.showOnlyLoaderDialog(context);
                                                  await homeController.incrementBlogViewer(homeController.blogList[index].id);
                                                  homeController.homeBlogVideo(homeController.blogList[index].blogImage);
                                                  global.hideLoader();
                                                  Get.to(() => AstrologyBlogDetailScreen(
                                                        image: "${homeController.blogList[index].blogImage}",
                                                        title: homeController.blogList[index].title,
                                                        description: homeController.blogList[index].description!,
                                                        extension: homeController.blogList[index].extension!,
                                                        controller: homeController.homeVideoPlayerController,
                                                      ));
                                                },
                                                child: Card(
                                                  elevation: 4,
                                                  margin: const EdgeInsets.only(right: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Container(
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Stack(children: [
                                                          ClipRRect(
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(10),
                                                              ),
                                                              child: homeController.blogList[index].extension == 'mp4' || homeController.blogList[index].extension == 'gif'
                                                                  ? Stack(
                                                                      alignment: Alignment.center,
                                                                      children: [
                                                                        CachedNetworkImage(
                                                                          imageUrl: '${global.imgBaseurl}${homeController.blogList[index].previewImage}',
                                                                          imageBuilder: (context, imageProvider) => Container(
                                                                            height: 110,
                                                                            width: Get.width,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.fill,
                                                                                image: imageProvider,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) => Image.asset(
                                                                            Images.blog,
                                                                            height: Get.height * 0.15,
                                                                            width: Get.width,
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                        Icon(
                                                                          Icons.play_arrow,
                                                                          size: 40,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl: '${global.imgBaseurl}${homeController.blogList[index].blogImage}',
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                        height: 110,
                                                                        width: Get.width,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          image: DecorationImage(
                                                                            fit: BoxFit.fill,
                                                                            image: imageProvider,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                      errorWidget: (context, url, error) => Image.asset(
                                                                        Images.blog,
                                                                        height: Get.height * 0.15,
                                                                        width: Get.width,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    )),
                                                          Positioned(
                                                            right: 7,
                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  padding: EdgeInsets.zero,
                                                                  backgroundColor: Colors.white.withOpacity(0.5),
                                                                  elevation: 0,
                                                                  minimumSize: const Size(50, 30), //height
                                                                  maximumSize: const Size(60, 30), //width
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                                                ),
                                                                onPressed: () {},
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.visibility,
                                                                      size: 20,
                                                                      color: Colors.black,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 5.0),
                                                                      child: Text(
                                                                        "${homeController.blogList[index].viewer}",
                                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          )
                                                        ]),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              SizedBox(
                                                                height: 42,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(bottom: 8.0),
                                                                  child: Text(
                                                                    homeController.blogList[index].title,
                                                                    textAlign: TextAlign.start,
                                                                    style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight.w400,
                                                                      letterSpacing: 0,
                                                                    ),
                                                                  ).translate(),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    child: Text(
                                                                      homeController.blogList[index].author,
                                                                      textAlign: TextAlign.center,
                                                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                        fontSize: 10,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Colors.grey[350],
                                                                        letterSpacing: 0,
                                                                      ),
                                                                    ).translate(),
                                                                  ),
                                                                  Text(
                                                                    "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.blogList[index].createdAt))}",
                                                                    textAlign: TextAlign.center,
                                                                    style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Colors.grey[350],
                                                                      letterSpacing: 0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<AstromallController>(builder: (astromallController) {
                        return astromallController.astroCategory.length == 0
                            ? SizedBox()
                            : SizedBox(
                                height: 200,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Shop at Astromall',
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              GestureDetector(
                                                onTap: () async {
                                                  final AstromallController astromallController = Get.find<AstromallController>();
                                                  astromallController.astroCategory.clear();
                                                  astromallController.isAllDataLoaded = false;
                                                  astromallController.update();
                                                  global.showOnlyLoaderDialog(context);
                                                  await astromallController.getAstromallCategory(false);
                                                  global.hideLoader();
                                                  Get.to(() => AstromallScreen());
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: astromallController.astroCategory.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                global.showOnlyLoaderDialog(context);
                                                astromallController.astroProduct.clear();
                                                astromallController.isAllDataLoadedForProduct = false;
                                                astromallController.productCatId = astromallController.astroCategory[index].id;
                                                astromallController.update();
                                                await astromallController.getAstromallProduct(astromallController.astroCategory[index].id, false);
                                                global.hideLoader();
                                                Get.to(
                                                  () => AstroProductScreen(
                                                    appbarTitle: astromallController.astroCategory[index].name,
                                                    productCategoryId: astromallController.astroCategory[index].id,
                                                    sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[index].categoryImage}",
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 100,
                                                margin: const EdgeInsets.only(top: 4, bottom: 4, right: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Get.theme.primaryColor, width: 4),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment.bottomCenter,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage("${global.imgBaseurl}${astromallController.astroCategory[index].categoryImage}"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.white,
                                                      width: Get.width,
                                                      height: 45,
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.all(8),
                                                      child: Text(
                                                        astromallController.astroCategory[index].name,
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Get.textTheme.bodyText2!.copyWith(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                                      ).translate(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return SizedBox(
                          height: 250,
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.only(top: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'Behind the scenes',
                                      style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                    ).translate(),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: Get.width,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        homeController.videoPlayerController!.value.isInitialized
                                            ? Card(
                                                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                child: SizedBox(
                                                  height: 200,
                                                  width: Get.width,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: AspectRatio(
                                                      aspectRatio: homeController.videoPlayerController!.value.aspectRatio,
                                                      child: VideoPlayer(
                                                        homeController.videoPlayerController!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        InkWell(
                                          onTap: () {
                                            homeController.playPauseVideo();
                                          },
                                          child: Icon(
                                            homeController.videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return homeController.clientReviews.length == 0
                            ? SizedBox()
                            : Card(
                                elevation: 0,
                                margin: EdgeInsets.only(top: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Clients Testimonials',
                                            style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                          ).translate(),
                                          GestureDetector(
                                            onTap: () async {
                                              global.showOnlyLoaderDialog(context);
                                              await homeController.getClientsTestimonals();
                                              global.hideLoader();
                                              Get.to(() => ClientsReviewScreen());
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[500],
                                              ),
                                            ).translate(),
                                          ),
                                        ],
                                      ),
                                      GetBuilder<HomeController>(
                                        builder: (controller) => Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                                                controller.update();
                                              },
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.grey[200],
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 4),
                                                  child: Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 15,
                                                    color: Get.theme.iconTheme.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 210,
                                                margin: EdgeInsets.only(left: 4, right: 4, top: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(color: Colors.grey),
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child: PageView.builder(
                                                  onPageChanged: (value) {},
                                                  itemCount: homeController.clientReviews.length,
                                                  controller: homeController.pageController,
                                                  itemBuilder: (context, index) => Column(
                                                    children: [
                                                      Text(
                                                        "${homeController.clientReviews[index].review}",
                                                        maxLines: 6,
                                                        textAlign: TextAlign.justify,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Get.theme.primaryTextTheme.bodyText2!.copyWith(
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 13,
                                                        ),
                                                      ).translate(),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                        child: Divider(height: 0),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Row(
                                                          children: [
                                                            homeController.clientReviews[index].profile == ""
                                                                ? Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(7),
                                                                      color: Get.theme.primaryColor,
                                                                      image: DecorationImage(
                                                                        image: AssetImage(Images.deafultUser),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl: '${global.imgBaseurl}${homeController.clientReviews[index].profile}',
                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                      height: 40,
                                                                      width: 40,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(7),
                                                                        color: Get.theme.primaryColor,
                                                                        image: DecorationImage(
                                                                          image: NetworkImage("${global.imgBaseurl}${homeController.clientReviews[index].profile}"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context, url, error) => Container(
                                                                      height: 40,
                                                                      width: 40,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(7),
                                                                        color: Get.theme.primaryColor,
                                                                        image: DecorationImage(
                                                                          image: AssetImage(Images.deafultUser),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                    child: Text(
                                                                      // ignore: unnecessary_null_comparison
                                                                      (homeController.clientReviews[index].name != null && homeController.clientReviews[index].name != '') ? "${homeController.clientReviews[index].name}" : 'User',
                                                                      style: Get.theme.primaryTextTheme.subtitle2!.copyWith(
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    ).translate(),
                                                                  ),
                                                                  Text(
                                                                    '${homeController.clientReviews[index].location}',
                                                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                      fontWeight: FontWeight.w300,
                                                                    ),
                                                                  ).translate(),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller.pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                                                controller.update();
                                              },
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.grey[200],
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Get.theme.iconTheme.color,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return homeController.astroNews.length == 0
                            ? SizedBox()
                            : SizedBox(
                                height: 260,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)} in News',
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() => AstrologerNewsScreen());
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: homeController.astroNews.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => BlogScreen(
                                                      link: homeController.astroNews[index].link,
                                                    ));
                                              },
                                              child: Card(
                                                elevation: 4,
                                                margin: EdgeInsets.only(right: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: 190,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(10),
                                                          topRight: Radius.circular(10),
                                                        ),
                                                        child: CachedNetworkImage(
                                                          imageUrl: '${global.imgBaseurl}${homeController.astroNews[index].bannerImage}',
                                                          imageBuilder: (context, imageProvider) => Container(
                                                            height: 110,
                                                            width: Get.width,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              image: DecorationImage(
                                                                fit: BoxFit.fill,
                                                                image: imageProvider,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                          errorWidget: (context, url, error) => Image.asset(
                                                            Images.blog,
                                                            height: Get.height * 0.15,
                                                            width: Get.width,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(bottom: 8),
                                                              child: Text(
                                                                homeController.astroNews[index].description,
                                                                textAlign: TextAlign.start,
                                                                maxLines: 2,
                                                                style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w400,
                                                                  letterSpacing: 0,
                                                                ),
                                                              ).translate(),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  homeController.astroNews[index].channel,
                                                                  textAlign: TextAlign.center,
                                                                  style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.grey[350],
                                                                    letterSpacing: 0,
                                                                  ),
                                                                ).translate(),
                                                                Text(
                                                                  "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astroNews[index].newsDate.toString()))}",
                                                                  textAlign: TextAlign.center,
                                                                  style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.grey[350],
                                                                    letterSpacing: 0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: SizedBox(
                            height: 110,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    DateTime dateBasic = DateTime.now();
                                    int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                                    int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                                    int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                                    int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                                    int formattedMint = int.parse(DateFormat('mm').format(dateBasic));

                                    global.showOnlyLoaderDialog(context);
                                    await kundliController.getBasicPanchangDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: 21.1255, lon: 73.1122, tzone: 5);
                                    global.hideLoader();
                                    Get.to(() => PanchangScreen());
                                  },
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Today's Panchang").translate(),
                                        Container(
                                          height: 25,
                                          width: 90,
                                          margin: EdgeInsets.only(right: 35, top: 5),
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Check Now',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              letterSpacing: -0.2,
                                              wordSpacing: 0,
                                            ),
                                          ).translate(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 110,
                                  width: 170,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(45),
                                      bottomRight: Radius.circular(45),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.todayPanchang)}',
                                      imageBuilder: (context, imageProvider) => Image.network(
                                        '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.todayPanchang)}',
                                        fit: BoxFit.fill,
                                      ),
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(45),
                                        bottomRight: Radius.circular(45),
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return homeController.astrologyVideo.length == 0
                            ? SizedBox()
                            : SizedBox(
                                height: 250,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Watch Astrology Videos',
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() => AstrologerVideoScreen());
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: homeController.astrologyVideo.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                global.showOnlyLoaderDialog(context);
                                                await homeController.youtubPlay(homeController.astrologyVideo[index].youtubeLink);
                                                global.hideLoader();
                                                Get.to(() => BlogScreen(
                                                      link: homeController.astrologyVideo[index].youtubeLink,
                                                      title: 'Video',
                                                      controller: homeController.youtubePlayerController,
                                                      date: '${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}',
                                                      videoTitle: homeController.astrologyVideo[index].videoTitle,
                                                    ));
                                              },
                                              child: Card(
                                                elevation: 4,
                                                margin: EdgeInsets.only(right: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: 230,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10),
                                                            ),
                                                            child: CachedNetworkImage(
                                                              imageUrl: '${global.imgBaseurl}${homeController.astrologyVideo[index].coverImage}',
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                height: 110,
                                                                width: Get.width,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  image: DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: imageProvider,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                              errorWidget: (context, url, error) => Image.asset(
                                                                Images.blog,
                                                                height: Get.height * 0.15,
                                                                width: Get.width,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 60,
                                                            child: Image.asset(
                                                              Images.youtube,
                                                              height: 120,
                                                              width: 120,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              homeController.astrologyVideo[index].videoTitle,
                                                              textAlign: TextAlign.start,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400,
                                                                letterSpacing: 0,
                                                              ),
                                                            ).translate(),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}",
                                                                  textAlign: TextAlign.center,
                                                                  style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.grey[350],
                                                                    letterSpacing: 0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.only(top: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'I am the Product Manager',
                                  style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                ).translate(),
                                Text(
                                  'share your feedback to help us improve the app',
                                  style: TextStyle(fontSize: 10),
                                ).translate(),
                                SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                    future: global.translatedText('Start typing here..'),
                                    builder: (context, snapshot) {
                                      return TextFormField(
                                        controller: homeController.feedbackController,
                                        maxLines: 8,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(5),
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: snapshot.data ?? 'Start typing here..',
                                          hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[500]),
                                        ),
                                      );
                                    }),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width / 2)),
                                          backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool isLogin = await global.isLogin();
                                          if (isLogin) {
                                            if (homeController.feedbackController.text == "") {
                                              global.showToast(
                                                message: 'Please enter feedback',
                                                textColor: global.textColor,
                                                bgColor: global.toastBackGoundColor,
                                              );
                                            } else {
                                              global.showOnlyLoaderDialog(context);
                                              await homeController.addFeedback(homeController.feedbackController.text);
                                              global.hideLoader();
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Send Feedback',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.black),
                                        ).translate(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10).copyWith(bottom: 65),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.grey[200],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        Images.confidential,
                                        height: 45,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Private &\nConfidential',
                                    textAlign: TextAlign.center,
                                    style: Get.theme.textTheme.subtitle1!.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ).translate(),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.grey[200],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        Images.verifiedAccount,
                                        height: 45,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Verified\nAstrologers',
                                    textAlign: TextAlign.center,
                                    style: Get.theme.textTheme.subtitle1!.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ).translate(),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.grey[200],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        Images.payment,
                                        height: 45,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Secure\nPayments',
                                    textAlign: TextAlign.center,
                                    style: Get.theme.textTheme.subtitle1!.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ).translate(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.only(top: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              global.showOnlyLoaderDialog(context);
                              bottomController.astrologerList = [];
                              bottomController.astrologerList.clear();
                              bottomController.isAllDataLoaded = false;
                              bottomController.update();
                              await bottomController.getAstrologerList(isLazyLoading: false);
                              global.hideLoader();
                              bottomController.setBottomIndex(1, 0);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidCommentDots,
                                      size: 13,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Chat with Astrologers',
                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.2,
                                          wordSpacing: 0,
                                        ),
                                      ).translate(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              global.showOnlyLoaderDialog(context);
                              bottomController.astrologerList = [];
                              bottomController.astrologerList.clear();
                              bottomController.isAllDataLoaded = false;
                              bottomController.update();
                              await bottomController.getAstrologerList(isLazyLoading: false);
                              global.hideLoader();
                              bottomController.setBottomIndex(3, 0);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 18,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Call with Astrologers',
                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.2,
                                          wordSpacing: 0,
                                        ),
                                      ).translate(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 100);
    path.lineTo(250, 100);
    path.lineTo(0, 100);
    path.lineTo(200, 300);
    path.lineTo(90, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
