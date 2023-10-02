// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:AstroGuru/controllers/astromallController.dart';
import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/callController.dart';
import 'package:AstroGuru/controllers/history_controller.dart';
import 'package:AstroGuru/controllers/search_controller.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/utils/images.dart';
import 'package:AstroGuru/views/astromall/astromallScreen.dart';
import 'package:AstroGuru/views/astromall/productDetailScreen.dart';
import 'package:AstroGuru/views/bottomNavigationBarScreen.dart';
import 'package:AstroGuru/views/callIntakeFormScreen.dart';
import 'package:AstroGuru/views/customer_support/customerSupportChatScreen.dart';
import 'package:AstroGuru/views/liveAstrologerList.dart';
import 'package:AstroGuru/views/paymentInformationScreen.dart';
import 'package:AstroGuru/views/profile/editUserProfileScreen.dart';
import 'package:AstroGuru/widget/popular_search_widget.dart';
import 'package:AstroGuru/widget/quickLinkWiget.dart';
import 'package:AstroGuru/widget/topServicesWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import '../controllers/astrologer_assistant_controller.dart';
import '../controllers/chatController.dart';
import '../controllers/customer_support_controller.dart';
import '../controllers/razorPayController.dart';
import '../controllers/reviewController.dart';
import '../controllers/walletController.dart';
import 'astrologerProfile/astrologerProfile.dart';

class SearchAstrologerScreen extends StatelessWidget {
  final String type;
  SearchAstrologerScreen({Key? key, this.type = 'Chat'}) : super(key: key);
  final ChatController chatController = ChatController();
  WalletController walletController = Get.find<WalletController>();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  CallController callController = Get.find<CallController>();
  SearchController searchControllerr = Get.find<SearchController>();
  HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SearchController searchController = Get.find<SearchController>();
        searchController.serachTextController.clear();
        searchController.searchText = "";
        searchController.update();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          leading: IconButton(
            onPressed: () {
              SearchController searchController = Get.find<SearchController>();
              searchController.serachTextController.clear();
              searchController.searchText = "";
              searchController.update();
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
          title: GetBuilder<SearchController>(builder: (searchController) {
            return FutureBuilder(
                future: global.translatedText('Search astrologers, astromall products'),
                builder: (context, snapdhot) {
                  return TextField(
                      controller: searchController.serachTextController,
                      onChanged: (value) async {
                        searchController.searchText = value;
                        if (value.length > 2) {
                          searchController.searchFnode.unfocus();
                          global.showOnlyLoaderDialog(context);
                          searchController.astrologerList.clear();
                          searchController.astroProduct.clear();
                          searchController.isAllDataLoaded = false;
                          searchController.isAllDataLoadedForAstromall = false;
                          searchController.searchString = value;
                          searchController.update();
                          await searchController.getSearchResult(value, null, false);
                          global.hideLoader();
                        }
                        searchController.update();
                      },
                      focusNode: searchControllerr.searchFnode,
                      decoration: InputDecoration(
                          hintText: snapdhot.data,
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          suffix: searchController.serachTextController.text != ""
                              ? GestureDetector(
                                  child: Icon(Icons.close),
                                  onTap: () {
                                    searchController.serachTextController.clear();
                                    searchController.searchText = '';
                                    searchControllerr.update();
                                  },
                                )
                              : SizedBox()));
                });
          }),
        ),
        body: GetBuilder<SearchController>(builder: (searchController) {
          return searchController.searchText == ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text('Top Services').translate(),
                      SizedBox(
                        height: 8,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          TopServicesWidget(
                            icon: Icons.phone,
                            color: Color.fromARGB(255, 212, 228, 241),
                            text: 'Call',
                            onTap: () {
                              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                              bottomNavigationController.setIndex(3, 0);
                              Get.to(() => BottomNavigationBarScreen(
                                    index: 3,
                                  ));
                            },
                          ),
                          TopServicesWidget(
                            icon: Icons.chat,
                            color: Color.fromARGB(255, 238, 221, 236),
                            text: 'Chat',
                            onTap: () {
                              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                              bottomNavigationController.setIndex(1, 0);
                              Get.to(() => BottomNavigationBarScreen(
                                    index: 1,
                                  ));
                            },
                          ),
                          TopServicesWidget(
                            icon: Icons.live_tv,
                            color: Color.fromARGB(255, 235, 236, 221),
                            text: 'Live',
                            onTap: () {
                              Get.to(() => LiveAstrologerListScreen());
                            },
                          ),
                          TopServicesWidget(
                              icon: Icons.shopping_bag,
                              color: Color.fromARGB(255, 223, 240, 221),
                              text: 'Astromall',
                              onTap: () {
                                Get.to(() => AstromallScreen());
                              })
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Quick Link').translate(),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickLinnkWidget(
                            text: 'Wallet',
                            image: Images.wallet,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                historyController.paymentAllDataLoaded = false;
                                historyController.walletTransactionList.clear();
                                historyController.walletAllDataLoaded = false;
                                historyController.update();
                                await historyController.getPaymentLogs(global.currentUserId!, false);
                                await historyController.getWalletTransaction(global.currentUserId!, false);
                                BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                bottomNavigationController.setIndex(4, 0);
                                callController.setTabIndex(0);
                                Get.to(() => BottomNavigationBarScreen(index: 4));
                              }
                            },
                          ),
                          QuickLinnkWidget(
                            text: 'Customer Support',
                            image: Images.customerService,
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
                          ),
                          QuickLinnkWidget(
                            text: 'Order History',
                            image: Images.shopBag,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                historyController.callHistoryList = [];
                                historyController.callHistoryList.clear();
                                historyController.callAllDataLoaded = false;
                                historyController.update();
                                await historyController.getCallHistory(global.currentUserId!, false);
                                BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                bottomNavigationController.setIndex(4, 1);
                                callController.setTabIndex(1);
                                Get.to(() => BottomNavigationBarScreen(index: 4));
                              }
                            },
                          ),
                          QuickLinnkWidget(
                            text: 'Profile',
                            image: Images.userProfile,
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                SplashController splashController = Get.find<SplashController>();
                                global.showOnlyLoaderDialog(context);
                                await splashController.getCurrentUserData();
                                global.hideLoader();
                                Get.to(() => EditUserProfile());
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: searchController.searchData.length,
                          itemBuilder: (context, index) {
                            return GetBuilder<SearchController>(builder: (c) {
                              return GestureDetector(
                                onTap: () {
                                  global.showOnlyLoaderDialog(context);
                                  searchController.selectSearchTab(index);
                                  searchController.astrologerList.clear();
                                  searchController.astroProduct.clear();
                                  searchController.isAllDataLoaded = false;
                                  searchController.isAllDataLoadedForAstromall = false;
                                  searchController.searchString = searchController.searchText;
                                  searchController.update();
                                  searchController.getSearchResult(searchController.searchText, null, false);
                                  global.hideLoader();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: searchController.searchData[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                                        border: Border.all(color: searchController.searchData[index].isSelected ? Get.theme.primaryColor : Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(searchController.searchData[index].title, style: TextStyle(fontSize: 13)).translate()),
                                ),
                              );
                            });
                          }),
                    ),
                    searchController.searchTabIndex == 0
                        ? Expanded(
                            child: searchController.astrologerList.isEmpty
                                ? searchResultNotFound()
                                : ListView.builder(
                                    itemCount: searchController.astrologerList.length,
                                    shrinkWrap: true,
                                    controller: searchController.searchScrollController,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          Get.find<ReviewController>().getReviewData(searchController.astrologerList[index].id!);
                                          global.showOnlyLoaderDialog(context);
                                          await bottomNavigationController.getAstrologerbyId(searchController.astrologerList[index].id!);
                                          global.hideLoader();
                                          Get.to(() => AstrologerProfile(
                                                index: index,
                                              ));
                                        },
                                        child: Column(
                                          children: [
                                            Card(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 10),
                                                              child: Container(
                                                                height: 65,
                                                                width: 65,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Get.theme.primaryColor),
                                                                  borderRadius: BorderRadius.circular(7),
                                                                ),
                                                                child: CircleAvatar(
                                                                  radius: 36,
                                                                  backgroundColor: Get.theme.primaryColor,
                                                                  child: CircleAvatar(
                                                                    radius: 35,
                                                                    backgroundColor: Colors.white,
                                                                    child: CachedNetworkImage(
                                                                      height: 55,
                                                                      width: 55,
                                                                      imageUrl: '${global.imgBaseurl}${searchController.astrologerList[index].profileImage}',
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
                                                            ),
                                                            Positioned(
                                                                right: 0,
                                                                top: 2,
                                                                child: Image.asset(
                                                                  Images.right,
                                                                  height: 18,
                                                                ))
                                                          ],
                                                        ),
                                                        RatingBar.builder(
                                                          initialRating: 0,
                                                          itemCount: 5,
                                                          allowHalfRating: false,
                                                          itemSize: 15,
                                                          ignoreGestures: true,
                                                          itemBuilder: (context, _) => Icon(
                                                            Icons.star,
                                                            color: Get.theme.primaryColor,
                                                          ),
                                                          onRatingUpdate: (rating) {},
                                                        ),
                                                        searchController.astrologerList[index].totalOrder == 0 || searchController.astrologerList[index].totalOrder == null
                                                            ? SizedBox()
                                                            : Text(
                                                                '${searchController.astrologerList[index].totalOrder} orders',
                                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                  fontWeight: FontWeight.w300,
                                                                  fontSize: 9,
                                                                ),
                                                              ).translate()
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              searchController.astrologerList[index].name!,
                                                            ).translate(),
                                                            searchController.astrologerList[index].allSkill == ""
                                                                ? const SizedBox()
                                                                : Text(
                                                                    searchController.astrologerList[index].allSkill ?? "",
                                                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                      fontWeight: FontWeight.w300,
                                                                      color: Colors.grey[600],
                                                                    ),
                                                                  ).translate(),
                                                            searchController.astrologerList[index].languageKnown == ""
                                                                ? const SizedBox()
                                                                : Text(
                                                                    searchController.astrologerList[index].languageKnown!,
                                                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                      fontWeight: FontWeight.w300,
                                                                      color: Colors.grey[600],
                                                                    ),
                                                                  ).translate(),
                                                            Text(
                                                              'Experience  : ${searchController.astrologerList[index].experienceInYears}',
                                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                fontWeight: FontWeight.w300,
                                                                color: Colors.grey[600],
                                                              ),
                                                            ).translate(),
                                                            Row(
                                                              children: [
                                                                searchController.astrologerList[index].isFreeAvailable == true
                                                                    ? Text(
                                                                        'FREE',
                                                                        style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500,
                                                                          letterSpacing: 0,
                                                                          color: Color.fromARGB(255, 167, 1, 1),
                                                                        ),
                                                                      ).translate()
                                                                    : const SizedBox(),
                                                                SizedBox(
                                                                  width: searchController.astrologerList[index].isFreeAvailable == true ? 10 : 0,
                                                                ),
                                                                Text(
                                                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${searchController.astrologerList[index].charge}/min',
                                                                  style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
                                                                    decoration: searchController.astrologerList[index].isFreeAvailable == true ? TextDecoration.lineThrough : null,
                                                                    color: searchController.astrologerList[index].isFreeAvailable == true ? Colors.grey : Color.fromARGB(255, 167, 1, 1),
                                                                    letterSpacing: 0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        type == 'Chat'
                                                            ? TextButton(
                                                                style: ButtonStyle(
                                                                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                                                  fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                                                  backgroundColor: searchController.astrologerList[index].chatStatus == "Online"
                                                                      ? MaterialStateProperty.all(Colors.green)
                                                                      : searchController.astrologerList[index].chatStatus == "Offline"
                                                                          ? MaterialStateProperty.all(Colors.red)
                                                                          : MaterialStateProperty.all(Colors.red),
                                                                  shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed: () async {
                                                                  bool isLogin = await global.isLogin();
                                                                  if (isLogin) {
                                                                    if (type == 'Chat') {
                                                                      double charge = searchController.astrologerList[index].charge != null ? double.parse(searchController.astrologerList[index].charge.toString()) : 0;
                                                                      if (charge * 5 <= global.splashController.currentUser!.walletAmount! || searchController.astrologerList[index].isFreeAvailable == true) {
                                                                        await bottomNavigationController.checkAlreadyInReq(searchController.astrologerList[index].id!);
                                                                        if (bottomNavigationController.isUserAlreadyInChatReq == false) {
                                                                          if (searchController.astrologerList[index].chatStatus == "Online" || searchController.astrologerList[index].chatStatus == "Wait Time") {
                                                                            global.showOnlyLoaderDialog(context);

                                                                            if (searchController.astrologerList[index].chatWaitTime != null) {
                                                                              if (searchController.astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                                                                await bottomNavigationController.changeOfflineStatus(searchController.astrologerList[index].id, "Online");
                                                                              }
                                                                            }
                                                                            await Get.to(() => CallIntakeFormScreen(
                                                                                  type: type,
                                                                                  // index: index,
                                                                                  astrologerId: searchController.astrologerList[index].id!,
                                                                                  astrologerName: searchController.astrologerList[index].name!,
                                                                                  astrologerProfile: searchController.astrologerList[index].profileImage!,
                                                                                  isFreeAvailable: searchController.astrologerList[index].isFreeAvailable!,
                                                                                ));
                                                                            global.hideLoader();
                                                                          } else if (searchController.astrologerList[index].chatStatus == "Offline") {
                                                                            bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                                                                              context,
                                                                              searchController.astrologerList[index].name!,
                                                                              true,
                                                                              searchController.astrologerList[index].id!,
                                                                              searchController.astrologerList[index].profileImage!,
                                                                              searchController.astrologerList[index].charge!,
                                                                              searchController.astrologerList[index].isFreeAvailable!,
                                                                            );
                                                                          }
                                                                        } else {
                                                                          bottomNavigationController.dialogForNotCreatingSession(context);
                                                                        }
                                                                      } else {
                                                                        global.showOnlyLoaderDialog(context);
                                                                        await walletController.getAmount();
                                                                        global.hideLoader();
                                                                        openBottomSheetRechrage(context, (charge * 5).toString(), 'chat', '${searchController.astrologerList[index].name!}');
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                                child: Text(
                                                                  '$type',
                                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                                                ).translate(),
                                                              )
                                                            : TextButton(
                                                                style: ButtonStyle(
                                                                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                                                  fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                                                  backgroundColor: searchController.astrologerList[index].callStatus == "Online"
                                                                      ? MaterialStateProperty.all(Colors.green)
                                                                      : searchController.astrologerList[index].callStatus == "Offline"
                                                                          ? MaterialStateProperty.all(Colors.red)
                                                                          : MaterialStateProperty.all(Colors.red),
                                                                  shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed: () async {
                                                                  bool isLogin = await global.isLogin();
                                                                  if (isLogin) {
                                                                    if (type == 'Call') {
                                                                      double charge = searchController.astrologerList[index].charge != null ? double.parse(searchController.astrologerList[index].charge.toString()) : 0;
                                                                      if (charge * 5 <= global.splashController.currentUser!.walletAmount! || searchController.astrologerList[index].isFreeAvailable == true) {
                                                                        await bottomNavigationController.checkAlreadyInReqForCall(searchController.astrologerList[index].id!);
                                                                        if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                                                          if (searchController.astrologerList[index].callStatus == "Online" || searchController.astrologerList[index].callStatus == "Wait Time") {
                                                                            global.showOnlyLoaderDialog(context);
                                                                            if (searchController.astrologerList[index].callWaitTime != null) {
                                                                              if (searchController.astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                                                                await bottomNavigationController.changeOfflineCallStatus(searchController.astrologerList[index].id, "Online");
                                                                              }
                                                                            }
                                                                            await Get.to(() => CallIntakeFormScreen(
                                                                                  astrologerProfile: searchController.astrologerList[index].profileImage ?? '',
                                                                                  type: "Call",
                                                                                  astrologerId: searchController.astrologerList[index].id!,
                                                                                  astrologerName: searchController.astrologerList[index].name ?? '',
                                                                                  isFreeAvailable: searchController.astrologerList[index].isFreeAvailable!,
                                                                                ));

                                                                            global.hideLoader();
                                                                          } else if (searchController.astrologerList[index].callStatus == "Offline") {
                                                                            bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                                                                              context,
                                                                              searchController.astrologerList[index].name ?? '',
                                                                              false,
                                                                              searchController.astrologerList[index].id!,
                                                                              searchController.astrologerList[index].profileImage ?? '',
                                                                              searchController.astrologerList[index].charge!,
                                                                              searchController.astrologerList[index].isFreeAvailable!,
                                                                            );
                                                                          }
                                                                        } else {
                                                                          bottomNavigationController.dialogForNotCreatingSession(context);
                                                                        }
                                                                      } else {
                                                                        global.showOnlyLoaderDialog(context);
                                                                        await walletController.getAmount();
                                                                        global.hideLoader();
                                                                        openBottomSheetRechrage(context, (charge * 5).toString(), 'call', '${searchController.astrologerList[index].name!}');
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                                child: Text(
                                                                  '$type',
                                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                                                ).translate(),
                                                              ),
                                                        type == "Chat"
                                                            ? searchController.astrologerList[index].chatStatus == "Offline"
                                                                ? Text(
                                                                    "Currently Offline",
                                                                    style: TextStyle(color: Colors.red, fontSize: 09),
                                                                  ).translate()
                                                                : searchController.astrologerList[index].chatStatus == "Wait Time"
                                                                    ? Text(
                                                                        searchController.astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes > 0 ? "Wait till - ${searchController.astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes} min" : "Wait till",
                                                                        style: TextStyle(color: Colors.red, fontSize: 09),
                                                                      ).translate()
                                                                    : SizedBox()
                                                            : searchController.astrologerList[index].callStatus == "Offline"
                                                                ? Text(
                                                                    "Currently Offline",
                                                                    style: TextStyle(color: Colors.red, fontSize: 09),
                                                                  ).translate()
                                                                : searchController.astrologerList[index].callStatus == "Wait Time"
                                                                    ? Text(
                                                                        searchController.astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes > 0 ? "Wait till - ${searchController.astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes} min" : "Wait till",
                                                                        style: TextStyle(color: Colors.red, fontSize: 09),
                                                                      ).translate()
                                                                    : SizedBox()
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            searchController.isMoreDataAvailable == true && !searchController.isAllDataLoaded && searchController.astrologerList.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                                            if (index == 2 - 1)
                                              const SizedBox(
                                                height: 30,
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : Expanded(
                            child: searchController.astroProduct.isEmpty
                                ? searchResultNotFound()
                                : ListView.builder(
                                    itemCount: searchController.astroProduct.length,
                                    shrinkWrap: true,
                                    controller: searchController.searchAstromallScrollController,
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          AstromallController astromallController = Get.find<AstromallController>();
                                          global.showOnlyLoaderDialog(context);
                                          print('selected product id:- ${searchController.astroProduct[index].id}');
                                          await astromallController.getproductById(searchController.astroProduct[index].id);
                                          global.hideLoader();
                                          Get.to(() => ProductDetailScreen(index: index));
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Card(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 38,
                                                      backgroundColor: Get.theme.primaryColor,
                                                      child: CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor: Colors.white,
                                                        child: CachedNetworkImage(
                                                          imageUrl: '${global.imgBaseurl}${searchController.astroProduct[index].productImage}',
                                                          imageBuilder: (context, imageProvider) => CircleAvatar(radius: 35, backgroundImage: imageProvider),
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
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(searchController.astroProduct[index].name).translate(),
                                                          Text(
                                                            '${searchController.astroProduct[index].features}',
                                                            style: Get.textTheme.bodySmall,
                                                          ).translate(),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Starting from: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${searchController.astroProduct[index].amount}/-',
                                                                style: Get.textTheme.bodySmall,
                                                              ).translate(),
                                                              Container(
                                                                padding: const EdgeInsets.all(5),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.grey, width: 2),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Text('Buy Now').translate(),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            searchController.isMoreDataAvailableForAstromall == true && !searchController.isAllDataLoadedForAstromall && searchController.astroProduct.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ],
                );
        }),
      ),
    );
  }

  Widget searchResultNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('oops! No result found').translate(),
          Text('try searching something else').translate(),
          Text(
            'Popular Searches',
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ).translate(),
          FittedBox(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              PopularSearchWidget(
                icon: Icons.phone,
                color: Color.fromARGB(255, 212, 228, 241),
                text: 'Call',
                onTap: () {
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(3, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 3,
                      ));
                },
              ),
              PopularSearchWidget(
                icon: Icons.chat,
                color: Color.fromARGB(255, 238, 221, 236),
                text: 'Chat',
                onTap: () {
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(1, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 1,
                      ));
                },
              ),
              PopularSearchWidget(
                icon: Icons.live_tv,
                color: Color.fromARGB(255, 235, 236, 221),
                text: 'Live',
                onTap: () {
                  Get.to(() => LiveAstrologerListScreen());
                },
              ),
              PopularSearchWidget(
                  icon: Icons.shopping_bag,
                  color: Color.fromARGB(255, 223, 240, 221),
                  text: 'Astromall',
                  onTap: () {
                    Get.to(() => AstromallScreen());
                  })
            ]),
          ),
        ],
      ),
    );
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance, String type, String astrologer) {
    Get.bottomSheet(
      Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.85,
                                    child: minBalance != '' ? Text('Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start $type with $astrologer ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)).translate() : const SizedBox(),
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: minBalance == '' ? const EdgeInsets.only(top: 8) : const EdgeInsets.only(top: 0),
                                      child: Icon(Icons.close, size: 18),
                                    ),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                                child: Text('Recharge Now', style: TextStyle(fontWeight: FontWeight.w500)).translate(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.lightbulb_rounded, color: Get.theme.primaryColor, size: 13),
                                  ),
                                  Expanded(child: Text('Tip:90% users recharge for 10 mins or more.', style: TextStyle(fontSize: 12)).translate())
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3.8 / 2.3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: walletController.rechrage.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.delete<RazorPayController>();
                          Get.to(() => PaymentInformationScreen(flag: 0, amount: double.parse(walletController.payment[index])));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.rechrage[index]}',
                              style: TextStyle(fontSize: 13),
                            )),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}
