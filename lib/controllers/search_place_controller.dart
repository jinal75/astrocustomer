import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class SearchPlaceController extends GetxController {
  GooglePlace? googlePlace;
  double? latitude;
  double? longitude;
  List<AutocompletePrediction> predictions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    String apiKey = "AIzaSyB3OHidxflWFxxR6aIqsvrP1_UxE0VhyJE";
    googlePlace = GooglePlace(apiKey);

    super.onInit();
  }

  autoCompleteSearch(String? value) async {
    if (value!.isNotEmpty) {
      var result = await googlePlace!.autocomplete.get(value);
      if (result != null && result.predictions != null) {
        print('place : ${result.predictions}');
        predictions = result.predictions!;

        update();
      }
    } else {
      predictions = [];
      update();
    }
  }
}
