import 'dart:io';

import 'package:AstroGuru/controllers/advancedPanchangController.dart';
import 'package:AstroGuru/controllers/kundliController.dart';
import 'package:AstroGuru/controllers/reviewController.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/views/placeOfBrithSearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../utils/images.dart';

// ignore: must_be_immutable
class PanchangScreen extends StatelessWidget {
  PanchangScreen({Key? key}) : super(key: key);
  final ReviewController reviewController = Get.find<ReviewController>();
  PanchangController panchangController = Get.find<PanchangController>();
  KundliController kundliController = Get.find<KundliController>();
  SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Panchang',
            style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
          ).translate(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                splashController.createAstrologerShareLink();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Images.whatsapp,
                        height: 40,
                        width: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Share', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is Panchang?',
                    style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                  ).translate(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 17),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('Panchag is the astrological daily calander based on the indian calendar.Daily panchang is one of the most sought Vedic astrology concepts,which conceptudlise the day\'s tithis , timing etc...').translate(),
                  )
                ],
              ),
            ),
            Container(
              width: Get.width,
              color: Color.fromARGB(255, 238, 236, 216),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter Location', style: Get.textTheme.subtitle1).translate(),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.to(() => PlaceOfBirthSearchScreen());
                    },
                    child: IgnorePointer(
                      child: TextField(
                        controller: kundliController.birthKundliPlaceController,
                        onChanged: (_) {},
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.edit),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: 'New Delhi',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<KundliController>(builder: (kundli) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Today\'s Panchang', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                            Text('${panchangController.formattedDate} |  ${kundliController.birthKundliPlaceController.text != "" ? kundliController.birthKundliPlaceController.text : 'New Delhi'}', style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey)).translate(),
                          ],
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [panchangTime('Sunrise-sunset', Get.theme.primaryColor, Icons.sunny, '${kundliController.kundliBasicPanchangDetail!.sunrise} - ${kundliController.kundliBasicPanchangDetail!.sunset}')],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 18),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('Nakshatra').translate(),
                            ),
                            Text('${kundliController.kundliBasicPanchangDetail!.nakshatra}', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey)).translate(),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('Yoga').translate(),
                            ),
                            Text(
                              '${kundliController.kundliBasicPanchangDetail!.yog != null ? kundliController.kundliBasicPanchangDetail!.yog : '--'}',
                              style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey),
                            ).translate()
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('Tithi').translate(),
                            ),
                            Text('${kundliController.kundliBasicPanchangDetail!.tithi}', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey)).translate()
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('weekday').translate(),
                            ),
                            Text('${kundliController.kundliBasicPanchangDetail!.day}', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey)).translate()
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('Karan').translate(),
                            ),
                            Text('${kundliController.kundliBasicPanchangDetail!.karan}', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey)).translate(),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget panchangTime(String title, Color borderColors, IconData icon, String timeText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          textAlign: TextAlign.left,
        ).translate(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: borderColors),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: borderColors,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(timeText).translate()
            ],
          ),
        )
      ],
    );
  }

  dialogForDate() {
    BuildContext context = Get.context!;
    showDialog(
        context: context,
        // barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Column(children: [
              Center(
                child: Text(
                  "You're all set!",
                  style: Get.theme.textTheme.headline1!.copyWith(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal),
                ),
              ),
              DatePickerDialog(
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                cancelText: '',
                confirmText: '',
              ),
            ]),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }
}
