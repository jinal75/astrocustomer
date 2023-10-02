import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/kundliController.dart';
import 'package:AstroGuru/controllers/liveController.dart';
import 'package:AstroGuru/model/kundli_model.dart';
import 'package:AstroGuru/views/liveAstrologerList.dart';
import 'package:AstroGuru/views/live_astrologer/live_astrologer_screen.dart';
import 'package:AstroGuru/widget/containerListTIleWidgte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../utils/images.dart';

// ignore: must_be_immutable
class BasicKundliScreen extends StatelessWidget {
  final KundliModel? userDetails;
  BasicKundliScreen({Key? key, this.userDetails}) : super(key: key);

  BottomNavigationController bottomController = Get.find<BottomNavigationController>();
  LiveController liveController = Get.find<LiveController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<KundliController>(builder: (kundliController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Basic Details',
                  style: Get.textTheme.bodyText1,
                ).translate(),
              ),
              SizedBox(height: 15),
              Container(
                  padding: EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: kundliController.kundliBasicDetail != null
                      ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Name').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${userDetails?.name}').translate(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Date').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      "${DateFormat("dd MMMM yyyy").format(userDetails!.birthDate)}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Time').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      "${userDetails!.birthTime}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Place').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${userDetails!.birthPlace}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Latitude').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.lat}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Longitude').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.lon}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Timezone').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.tzone}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Sunrise').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.sunrise}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Sunset').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.sunset}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Ayanamsha').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.ayanamsha}'),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : SizedBox()),
              SizedBox(
                height: 10,
              ),
              Text(
                'Maglik Analysis',
                style: Get.textTheme.bodyText1,
              ).translate(),
              SizedBox(
                height: 10,
              ),
              ContainerListTileWidget(
                color: Colors.green,
                title: '${userDetails?.name}',
                doshText: 'NO',
                subTitle: '',
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Panchang Details',
                style: Get.textTheme.bodyText1,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Tithi').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.tithi}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Karan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.karan}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Yog').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                '${kundliController.kundliBasicPanchangDetail!.yog != null ? kundliController.kundliBasicPanchangDetail!.yog : '--'}',
                              ).translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Nakshtra').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.nakshatra}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Sunrise').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.sunrise}'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Sunset').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.sunset}'),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                'Avakhada Details',
                style: Get.textTheme.bodyText1,
              ).translate(),
              SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Varna').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.varna}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Vashya').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                "${kundliController.kundliAvakhadaDetail!.vashya}",
                              ).translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Yoni').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                "${kundliController.kundliAvakhadaDetail!.yoni}",
                              ).translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Gan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.gan}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Nadi').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.nadi}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Sign').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.sign}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Sign Lord').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.signLord}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              // width: 90,
                              child: Text('Nakshatra-Charan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.naksahtra}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Yog').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.yog}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Karan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.karan}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Tithi').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.tithi}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Yunja').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.yunja}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Tatva').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.tatva}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              // width: 100,
                              child: Text('Name albhabet').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.nameAlphabet}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Paya').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.paya}').translate(),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              bottomController.liveAstrologer.length == 0
                  ? const SizedBox()
                  : SizedBox(
                      height: 270,
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Unable to understand your Kundli?',
                                          style: Get.theme.primaryTextTheme.bodyText1!.copyWith(fontWeight: FontWeight.w500),
                                        ).translate(),
                                        Text(
                                          'Contect with astrologers',
                                          style: Get.theme.primaryTextTheme.bodyText1!.copyWith(fontSize: 10),
                                        ).translate(),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
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
                              GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                                return bottomNavigationController.liveAstrologer.length == 0
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 180,
                                        child: Card(
                                          elevation: 0,
                                          margin: EdgeInsets.only(top: 6),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GetBuilder<BottomNavigationController>(
                                                  builder: (c) {
                                                    return Expanded(
                                                      child: ListView.builder(
                                                        itemCount: bottomNavigationController.liveAstrologer.length,
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        padding: EdgeInsets.only(top: 10, left: 10),
                                                        itemBuilder: (context, index) {
                                                          return GestureDetector(
                                                              onTap: () async {
                                                                bottomController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != bottomNavigationController.liveAstrologer[index].astrologerId).toList();
                                                                bottomController.update();
                                                                await liveController.getWaitList(bottomNavigationController.liveAstrologer[index].channelName);
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
                                                                Get.to(
                                                                  () => LiveAstrologerScreen(
                                                                    token: bottomNavigationController.liveAstrologer[index].token,
                                                                    channel: bottomNavigationController.liveAstrologer[index].channelName,
                                                                    astrologerName: bottomNavigationController.liveAstrologer[index].name,
                                                                    astrologerProfile: bottomNavigationController.liveAstrologer[index].profileImage,
                                                                    astrologerId: bottomNavigationController.liveAstrologer[index].astrologerId,
                                                                    isFromHome: true,
                                                                    charge: bottomNavigationController.liveAstrologer[index].charge,
                                                                    isForLiveCallAcceptDecline: false,
                                                                    isFromNotJoined: false,
                                                                    isFollow: bottomNavigationController.liveAstrologer[index].isFollow!,
                                                                    videoCallCharge: bottomNavigationController.liveAstrologer[index].videoCallRate,
                                                                  ),
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                  child: Stack(alignment: Alignment.bottomCenter, children: [
                                                                bottomNavigationController.liveAstrologer[index].profileImage == ""
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
                                                                            image: bottomNavigationController.liveAstrologer[index].profileImage == ""
                                                                                ? DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: AssetImage(
                                                                                      Images.deafultUser,
                                                                                    ),
                                                                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))
                                                                                : DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: NetworkImage(
                                                                                      '${global.imgBaseurl}${bottomNavigationController.liveAstrologer[index].profileImage}',
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
                                                                              '${bottomNavigationController.liveAstrologer[index].name}',
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
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
