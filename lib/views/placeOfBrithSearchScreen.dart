import 'package:AstroGuru/controllers/IntakeController.dart';
import 'package:AstroGuru/controllers/callController.dart';

import 'package:AstroGuru/controllers/kundliController.dart';
import 'package:AstroGuru/controllers/kundliMatchingController.dart';
import 'package:AstroGuru/controllers/reportController.dart';
import 'package:AstroGuru/controllers/search_controller.dart';
import 'package:AstroGuru/controllers/search_place_controller.dart';
import 'package:AstroGuru/controllers/userProfileController.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;

import '../widget/commonAppbar.dart';

// ignore: must_be_immutable
class PlaceOfBirthSearchScreen extends StatelessWidget {
  final int? flagId;
  PlaceOfBirthSearchScreen({Key? key, this.flagId}) : super(key: key);
  UserProfileController userProfileController = Get.find<UserProfileController>();
  KundliController kundliController = Get.find<KundliController>();
  IntakeController callIntakeController = Get.find<IntakeController>();
  ReportController reportController = Get.find<ReportController>();
  KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();
  CallController callController = Get.find<CallController>();
  SearchController searchController = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CommonAppBar(
          title: 'Place of Birth',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<SearchPlaceController>(builder: (searchPlaceController) {
          return Column(
            children: [
              FutureBuilder(
                  future: global.translatedText("Search City"),
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (value) async {
                          await searchPlaceController.autoCompleteSearch(value);
                        },
                        controller: searchPlaceController.searchController,
                        decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Get.theme.iconTheme.color,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            hintText: snapshot.data ?? 'Search City',
                            hintStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    );
                  }),
              Expanded(
                child: ListView.builder(
                  itemCount: searchPlaceController.predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(searchPlaceController.predictions[index].description ?? "null"),
                      onTap: () async {
                        List<Location> location = await locationFromAddress(searchPlaceController.predictions[index].description.toString());
                        kundliController.lat = location[0].latitude;
                        kundliController.long = location[0].longitude;

                        kundliMatchingController.lat = location[0].latitude;
                        kundliMatchingController.long = location[0].longitude;
                        print('${location[0].latitude} :- location');
                        print('${location[0].longitude} :- location');
                        await kundliController.getGeoCodingLatLong(latitude: location[0].latitude, longitude: location[0].latitude);
                        searchPlaceController.searchController.text = searchPlaceController.predictions[index].description!;
                        searchPlaceController.update();
                        kundliController.birthKundliPlaceController.text = searchPlaceController.predictions[index].description!;
                        kundliController.update();

                        kundliController.editBirthPlaceController.text = searchPlaceController.predictions[index].description!;
                        kundliController.update();
                        if (flagId == 1) {
                          kundliMatchingController.cBoysBirthPlace.text = searchPlaceController.predictions[index].description!;
                          kundliMatchingController.update();
                        }
                        if (flagId == 2) {
                          kundliMatchingController.cGirlBirthPlace.text = searchPlaceController.predictions[index].description!;
                          kundliMatchingController.update();
                        }
                        if (flagId == 4) {
                          userProfileController.addressController.text = searchPlaceController.predictions[index].description!;
                        }
                        if (flagId == 3) {
                          userProfileController.placeBirthController.text = searchPlaceController.predictions[index].description!;
                        }
                        if (flagId == 5) {
                          callIntakeController.placeController.text = searchPlaceController.predictions[index].description!;
                        }
                        if (flagId == 6) {
                          callIntakeController.partnerPlaceController.text = searchPlaceController.predictions[index].description!;
                        }
                        if (flagId == 7) {
                          reportController.placeController.text = searchPlaceController.predictions[index].description!;
                          reportController.update();
                        }
                        if (flagId == 8) {
                          reportController.partnerPlaceController.text = searchPlaceController.predictions[index].description!;
                          reportController.update();
                        }
                        callIntakeController.update();
                        Get.back();
                      },
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
}
