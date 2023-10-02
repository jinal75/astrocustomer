// ignore_for_file: must_be_immutable

import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/chatController.dart';
import 'package:AstroGuru/controllers/filtterTabController.dart';
import 'package:AstroGuru/controllers/languageController.dart';
import 'package:AstroGuru/controllers/reportController.dart';
import 'package:AstroGuru/controllers/reviewController.dart';
import 'package:AstroGuru/controllers/skillController.dart';
import 'package:AstroGuru/controllers/walletController.dart';
import 'package:AstroGuru/main.dart';
import 'package:AstroGuru/utils/images.dart';
import 'package:AstroGuru/views/addMoneyToWallet.dart';
import 'package:AstroGuru/views/astrologerProfile/astrologerProfile.dart';
import 'package:AstroGuru/views/callIntakeFormScreen.dart';
import 'package:AstroGuru/views/chat/incoming_chat_request.dart';
import 'package:AstroGuru/views/paymentInformationScreen.dart';
import 'package:AstroGuru/views/searchAstrologerScreen.dart';
import 'package:AstroGuru/widget/customAppbarWidget.dart';
import 'package:AstroGuru/widget/drawerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/razorPayController.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final drawerKey = new GlobalKey<ScaffoldState>();

  FiltterTabController filtterTabController = Get.find<FiltterTabController>();

  SkillController skillController = Get.find<SkillController>();

  LanguageController languageController = Get.find<LanguageController>();

  ReportController reportController = Get.find<ReportController>();

  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();

  WalletController walletController = Get.find<WalletController>();

  ChatController cController = Get.find<ChatController>();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    global.sp = await SharedPreferences.getInstance();
    await global.sp!.reload();
    global.sp = global.sp;
    if (global.sp!.getInt('chatBottom') == 1) {
      chatController.chatBottom = true;
      chatController.update();
    } else {
      chatController.chatBottom = false;
      chatController.update();
    }
    print(global.sp);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bottomNavigationController.setBottomIndex(0, 1);
        return false;
      },
      child: Scaffold(
        drawer: DrawerWidget(),
        appBar: CustomAppBar(
          flagId: 1,
          onBackPressed: () {},
          scaffoldKey: GlobalKey<ScaffoldState>(),
          title: 'Chat with Astrologer',
          titleStyle: Get.theme.primaryTextTheme.subtitle2!.copyWith(fontWeight: FontWeight.w300),
          bgColor: Get.theme.primaryColor,
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => AddmoneyToWallet());
              },
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  global.splashController.currentUser?.walletAmount != null
                      ? Container(
                          padding: EdgeInsets.all(2),
                          margin: EdgeInsets.symmetric(vertical: 17),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                            style: Get.theme.primaryTextTheme.bodySmall,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SearchAstrologerScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: Get.theme.iconTheme.color,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                openBottomSheetFilter(context);
                skillController.getSkills();
                languageController.getLanguages();
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesomeIcons.filter,
                      size: 20,
                      color: Get.theme.iconTheme.color,
                    ),
                  ),
                  bottomNavigationController.applyFilter
                      ? Positioned(
                          right: 4,
                          top: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 4,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
        body: GetBuilder<ChatController>(
          builder: (chatController) {
            return DefaultTabController(
              length: chatController.categoryList.length,
              child: Column(
                children: [
                  TabBar(
                    padding: EdgeInsets.only(top: 10),
                    controller: chatController.categoryTab,
                    isScrollable: true,
                    onTap: (value) async {
                      chatController.isSelected = value;
                      if (value == 0) {
                        global.showOnlyLoaderDialog(context);
                        bottomNavigationController.astrologerList = [];
                        bottomNavigationController.astrologerList.clear();
                        bottomNavigationController.isAllDataLoaded = false;
                        bottomNavigationController.update();
                        await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                        global.hideLoader();
                      } else {
                        for (var i = 0; i < chatController.categoryList.length; i++) {
                          if (value == i) {
                            bottomNavigationController.astrologerList = [];
                            bottomNavigationController.astrologerList.clear();
                            bottomNavigationController.isAllDataLoaded = false;
                            bottomNavigationController.update();
                            global.showOnlyLoaderDialog(context);
                            await bottomNavigationController.astroCat(id: chatController.categoryList[i].id!, isLazyLoading: false);
                            global.hideLoader();
                          }
                        }
                      }
                      chatController.update();
                    },
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    tabs: List.generate(chatController.categoryList.length, (index) {
                      return GetBuilder<ChatController>(builder: (chatco) {
                        return SizedBox(
                          height: 30,
                          child: Chip(
                            padding: EdgeInsets.only(bottom: 5),
                            backgroundColor: chatController.isSelected == index ? Colors.transparent : Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: chatController.isSelected == index ? Get.theme.primaryColor : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(7)),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    height: 20,
                                    width: 20,
                                    imageUrl: '${global.imgBaseurl}${chatController.categoryList[index].image}',
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.grid_view_rounded, color: Get.theme.primaryColor, size: 20),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    chatController.categoryList[index].name,
                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                                  ).translate(),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                  GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                    return bottomNavigationController.astrologerList.length == 0
                        ? Container(
                            height: Get.height * 0.63,
                            child: Center(
                              child: Text(
                                'Astrologer not available',
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                              ).translate(),
                            ),
                          )
                        : Expanded(
                            child: TabBarView(
                            controller: chatController.categoryTab,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(chatController.categoryList.length, (index) {
                              return RefreshIndicator(
                                onRefresh: () async {
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
                                },
                                child: TabViewWidget(
                                  astrologerList: bottomNavigationController.astrologerList,
                                ),
                              );
                            }),
                          ));
                  }),
                ],
              ),
            );
          },
        ),
        bottomSheet: GetBuilder<ChatController>(builder: (C) {
          return chatController.chatBottom == true
              ? Container(
                  color: Get.theme.primaryColor,
                  height: 40,
                  width: Get.width,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Start chat with ${cController.bottomAstrologerName}').translate(),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          cController.bottomAstrologerName = global.sp!.getString('bottomAstrologerName') ?? '';
                          cController.bottomAstrologerProfile = global.sp!.getString('bottomAstrologerProfile') ?? '';
                          cController.bottomFirebaseChatId = global.sp!.getString('bottomFirebaseChatId') ?? '';
                          cController.bottomChatId = global.sp!.getInt('bottomChatId');
                          cController.bottomAstrologerId = global.sp!.getInt('bottomAstrologerId');
                          cController.bottomFcmToken = global.sp!.getString('bottomFcmToken');
                          cController.update();
                          Get.to(() => IncomingChatRequest(
                                astrologerName: cController.bottomAstrologerName,
                                profile: cController.bottomAstrologerProfile,
                                fireBasechatId: cController.bottomFirebaseChatId ?? "",
                                chatId: cController.bottomChatId!,
                                astrologerId: cController.bottomAstrologerId!,
                                fcmToken: cController.bottomFcmToken,
                              ));
                        },
                        child: Text(
                          'Start',
                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                        ).translate(),
                      ),
                    ],
                  ),
                )
              : const SizedBox();
        }),
      ),
    );
  }

  void openBottomSheetFilter(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sort & Filter').translate(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Obx(
                    () => RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: filtterTabController.filterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          filtterTabController.selectedFilterIndex.value = index;
                          filtterTabController.update();
                        },
                        tabs: List.generate(
                          filtterTabController.filtterList.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: filtterTabController.selectedFilterIndex.value == ind ? Colors.white : Colors.grey[50],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: filtterTabController.selectedFilterIndex.value == ind ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        filtterTabController.filtterList[ind],
                                        style: TextStyle(color: Colors.black54),
                                      ).translate(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBarView(
                      controller: filtterTabController.filterTab,
                      children: [
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<ReportController>(
                            builder: (rpcont) {
                              return GetBuilder<SkillController>(
                                builder: (c) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: ListView.builder(
                                          itemCount: reportController.sorting.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              groupValue: reportController.groupValue,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.zero,
                                              activeColor: Colors.black,
                                              value: reportController.sorting[index].id,
                                              onChanged: (val) {
                                                reportController.groupValue = val!;

                                                reportController.update();
                                              },
                                              title: Text(reportController.sorting[index].name!).translate(),
                                            );
                                          }));
                                },
                              );
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<SkillController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                    itemCount: skillController.skillList.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: Colors.black,
                                        value: skillController.skillList[index].isSelected,
                                        onChanged: (value) {
                                          skillController.skillList[index].isSelected = value!;
                                          skillController.update();
                                        },
                                        title: Text(skillController.skillList[index].name).translate(),
                                      );
                                    },
                                  ));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<LanguageController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: languageController.languageList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: languageController.languageList[index].isSelected,
                                          onChanged: (value) {
                                            languageController.languageList[index].isSelected = value!;
                                            languageController.update();
                                          },
                                          title: Text(languageController.languageList[index].languageName).translate(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<FiltterTabController>(builder: (c) {
                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: ListView.builder(
                                    itemCount: filtterTabController.gender.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: Colors.black,
                                        value: filtterTabController.gender[index].isCheck,
                                        onChanged: (value) {
                                          filtterTabController.gender[index].isCheck = value!;
                                          filtterTabController.update();
                                        },
                                        title: Text(filtterTabController.gender[index].name).translate(),
                                      );
                                    }));
                          }),
                        )),
                        SizedBox()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: 0,
                          child: TextButton(
                            onPressed: () async {
                              skillController.skillFilterList = [];
                              filtterTabController.genderFilterList = [];
                              languageController.languageFilterList = [];
                              reportController.sortingFilter = null;
                              for (var i = 0; i < skillController.skillList.length; i++) {
                                skillController.skillList[i].isSelected = false;

                                skillController.update();
                              }
                              for (var i = 0; i < languageController.languageList.length; i++) {
                                languageController.languageList[i].isSelected = false;

                                languageController.update();
                              }
                              for (var i = 0; i < filtterTabController.gender.length; i++) {
                                filtterTabController.gender[i].isCheck = false;

                                filtterTabController.update();
                              }
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.astrologerList.clear();
                              bottomNavigationController.isAllDataLoaded = false;
                              bottomNavigationController.skillFilterList = skillController.skillFilterList;
                              bottomNavigationController.genderFilterList = filtterTabController.genderFilterList;
                              bottomNavigationController.languageFilter = languageController.languageFilterList;
                              bottomNavigationController.applyFilter = false;
                              bottomNavigationController.update();
                              Get.back();
                              global.showOnlyLoaderDialog(context);
                              await bottomNavigationController.getAstrologerList(skills: skillController.skillFilterList, gender: filtterTabController.genderFilterList, language: languageController.languageFilterList, isLazyLoading: false);
                              global.hideLoader();

                              reportController.groupValue = 0;
                              print('done');
                              reportController.update();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black54),
                            ).translate(),
                          ),
                        )),
                        Expanded(child: GetBuilder<SkillController>(
                          builder: (controller) {
                            return SizedBox(
                              width: 80,
                              height: 55,
                              child: TextButton(
                                onPressed: () async {
                                  skillController.skillFilterList = [];
                                  filtterTabController.genderFilterList = [];
                                  languageController.languageFilterList = [];
                                  reportController.sortingFilter = null;
                                  for (var i = 0; i < skillController.skillList.length; i++) {
                                    if (skillController.skillList[i].isSelected == true) {
                                      skillController.skillFilterList.add(skillController.skillList[i].id!);
                                      skillController.update();
                                    }
                                  }
                                  for (var i = 0; i < filtterTabController.gender.length; i++) {
                                    if (filtterTabController.gender[i].isCheck == true) {
                                      filtterTabController.genderFilterList.add(filtterTabController.gender[i].name);
                                      filtterTabController.update();
                                    }
                                  }
                                  for (var i = 0; i < languageController.languageList.length; i++) {
                                    if (languageController.languageList[i].isSelected == true) {
                                      languageController.languageFilterList.add(languageController.languageList[i].id!);
                                      languageController.update();
                                    }
                                  }
                                  for (var i = 0; i < reportController.sorting.length; i++) {
                                    if (reportController.groupValue == reportController.sorting[i].id) {
                                      reportController.sortingFilter = reportController.sorting[i].value;
                                      reportController.update();
                                    }
                                  }
                                  Get.back();
                                  bottomNavigationController.astrologerList = [];
                                  bottomNavigationController.astrologerList.clear();
                                  bottomNavigationController.isAllDataLoaded = false;
                                  bottomNavigationController.applyFilter = true;
                                  bottomNavigationController.skillFilterList = skillController.skillFilterList;
                                  bottomNavigationController.genderFilterList = filtterTabController.genderFilterList;
                                  bottomNavigationController.languageFilter = languageController.languageFilterList;
                                  bottomNavigationController.sortingFilter = reportController.sortingFilter;
                                  bottomNavigationController.update();
                                  global.showOnlyLoaderDialog(context);
                                  await bottomNavigationController.getAstrologerList(skills: skillController.skillFilterList, gender: filtterTabController.genderFilterList, language: languageController.languageFilterList, sortBy: reportController.sortingFilter, isLazyLoading: false);
                                  global.hideLoader();

                                  skillController.addFilter(catId: cController.categoryList[cController.isSelected].id, skills: skillController.skillFilterList, language: languageController.languageFilterList, gender: filtterTabController.genderFilterList, sortBy: reportController.sortingFilter);
                                },
                                child: Text('Apply').translate(),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                                  backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

class TabViewWidget extends StatelessWidget {
  final List astrologerList;
  final ChatController chatController = ChatController();
  WalletController walletController = Get.find<WalletController>();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  TabViewWidget({
    required this.astrologerList,
    Key? key,
  }) : super(key: key);

  ScrollController chatScrollController = ScrollController();

  void paginateTask() {
    chatScrollController.addListener(() async {
      if (chatScrollController.position.pixels == chatScrollController.position.maxScrollExtent && !bottomNavigationController.isAllDataLoaded) {
        bottomNavigationController.isMoreDataAvailable = true;
        bottomNavigationController.update();
        if (bottomNavigationController.selectedCatId == null || bottomNavigationController.selectedCatId! == 0) {
          if (bottomNavigationController.isChatAstroDataLoadedOnce == false) {
            bottomNavigationController.isChatAstroDataLoadedOnce = true;
            bottomNavigationController.update();
            await bottomNavigationController.getAstrologerList(skills: bottomNavigationController.skillFilterList, gender: bottomNavigationController.genderFilterList, language: bottomNavigationController.languageFilter, sortBy: bottomNavigationController.sortingFilter, isLazyLoading: true);
            bottomNavigationController.isChatAstroDataLoadedOnce = false;
            bottomNavigationController.update();
          }
        } else {
          bottomNavigationController.astrologerList = [];
          bottomNavigationController.astrologerList.clear();
          bottomNavigationController.isAllDataLoaded = false;
          bottomNavigationController.update();
          await bottomNavigationController.astroCat(id: bottomNavigationController.selectedCatId!, isLazyLoading: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    paginateTask();
    return ListView.builder(
      itemCount: astrologerList.length,
      controller: chatScrollController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            Get.find<ReviewController>().getReviewData(astrologerList[index].id);
            global.showOnlyLoaderDialog(context);
            await bottomNavigationController.getAstrologerbyId(astrologerList[index].id);
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
                                    radius: 35,
                                    backgroundColor: Colors.white,
                                    child: CachedNetworkImage(
                                      height: 55,
                                      width: 55,
                                      imageUrl: '${global.imgBaseurl}${astrologerList[index].profileImage}',
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
                          astrologerList[index].totalOrder == 0 || astrologerList[index].totalOrder == null
                              ? SizedBox()
                              : Text(
                                  '${astrologerList[index].totalOrder} orders',
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
                                astrologerList[index].name,
                              ).translate(),
                              astrologerList[index].allSkill == ""
                                  ? const SizedBox()
                                  : Text(
                                      astrologerList[index].allSkill,
                                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[600],
                                      ),
                                    ).translate(),
                              astrologerList[index].languageKnown == ""
                                  ? const SizedBox()
                                  : Text(
                                      astrologerList[index].languageKnown,
                                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[600],
                                      ),
                                    ).translate(),
                              Text(
                                'Experience : ${astrologerList[index].experienceInYears} Years',
                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey[600],
                                ),
                              ).translate(),
                              Row(
                                children: [
                                  astrologerList[index].isFreeAvailable == true
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
                                    width: astrologerList[index].isFreeAvailable == true ? 10 : 0,
                                  ),
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astrologerList[index].charge}/min',
                                    style: Get.theme.textTheme.subtitle1!.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0,
                                      decoration: astrologerList[index].isFreeAvailable == true ? TextDecoration.lineThrough : null,
                                      color: astrologerList[index].isFreeAvailable == true ? Colors.grey : Color.fromARGB(255, 167, 1, 1),
                                    ),
                                  ).translate(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                              fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                              backgroundColor: astrologerList[index].chatStatus == "Online"
                                  ? MaterialStateProperty.all(Colors.green)
                                  : astrologerList[index].chatStatus == "Offline"
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
                                if (astrologerList[index].charge * 5 <= global.splashController.currentUser!.walletAmount || astrologerList[index].isFreeAvailable == true) {
                                  await bottomNavigationController.checkAlreadyInReq(astrologerList[index].id);
                                  if (bottomNavigationController.isUserAlreadyInChatReq == false) {
                                    if (astrologerList[index].chatStatus == "Online" || astrologerList[index].chatStatus == "Wait Time") {
                                      global.showOnlyLoaderDialog(context);

                                      if (astrologerList[index].chatWaitTime != null) {
                                        if (astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                          await bottomNavigationController.changeOfflineStatus(astrologerList[index].id, "Online");
                                        }
                                      }
                                      await Get.to(() => CallIntakeFormScreen(
                                            type: "Chat",
                                            astrologerId: astrologerList[index].id,
                                            astrologerName: astrologerList[index].name,
                                            astrologerProfile: astrologerList[index].profileImage,
                                            isFreeAvailable: astrologerList[index].isFreeAvailable,
                                          ));
                                      global.hideLoader();
                                    } else if (astrologerList[index].chatStatus == "Offline") {
                                      bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                                        context,
                                        astrologerList[index].name,
                                        true,
                                        astrologerList[index].id,
                                        astrologerList[index].profileImage,
                                        astrologerList[index].charge,
                                        astrologerList[index].isFreeAvailable,
                                      );
                                    }
                                  } else {
                                    bottomNavigationController.dialogForNotCreatingSession(context);
                                  }
                                } else {
                                  global.showOnlyLoaderDialog(context);
                                  await walletController.getAmount();
                                  global.hideLoader();
                                  openBottomSheetRechrage(context, (astrologerList[index].charge * 5).toString(), astrologerList[index].name);
                                }
                              }
                            },
                            child: Text(
                              'Chat',
                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                            ).translate(),
                          ),
                          astrologerList[index].chatStatus == "Offline"
                              ? Text(
                                  "Currently Offline",
                                  style: TextStyle(color: Colors.red, fontSize: 09),
                                ).translate()
                              : astrologerList[index].chatStatus == "Wait Time"
                                  ? Text(
                                      astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes > 0 ? "Wait till - ${astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes} min" : "Wait till",
                                      style: TextStyle(color: Colors.red, fontSize: 09),
                                    ).translate()
                                  : SizedBox()
                        ],
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationController.isMoreDataAvailable == true && !bottomNavigationController.isAllDataLoaded && astrologerList.length - 1 == index
                  ? Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : const SizedBox(),
              if (index == astrologerList.length - 1)
                const SizedBox(
                  height: 30,
                )
            ],
          ),
        );
      },
    );
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance, String astrologer) {
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
                                    child: minBalance != '' ? Text('Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start chat with $astrologer ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)).translate() : const SizedBox(),
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
