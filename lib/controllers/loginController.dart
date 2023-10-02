import 'dart:async';
import 'dart:developer';
import 'package:AstroGuru/controllers/homeController.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/main.dart';
import 'package:AstroGuru/model/login_model.dart';
import 'package:AstroGuru/utils/services/api_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import '../model/device_info_login_model.dart';
import '../views/bottomNavigationBarScreen.dart';
import '../views/verifyPhoneScreen.dart';
import 'package:AstroGuru/utils/global.dart' as global;

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  SplashController splashController = Get.find<SplashController>();

  double second = 0;
  var maxSecond;
  String countryCode = "+91";
  Timer? time;
  Timer? time2;
  String smsCode = "";
  String verificationId = "";
  String? errorText;
  APIHelper apiHelper = APIHelper();
  String selectedCountryCode = "+91";
  var flag = '🇮🇳';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    // ignore: unnecessary_statements
    print("despose");
  }

  timer() {
    maxSecond = 60;
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (maxSecond > 0) {
        maxSecond--;
        update();
      } else {
        time!.cancel();
      }
    });
    time2 = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (second < 0.9) {
        second = second + 0.02;
        update();
      } else {
        time2!.cancel();
        update();
      }
    });
  }

  updateCountryCode(value) {
    countryCode = value.toString();
    print('countryCode -> $countryCode');
    update();
  }

  bool validedPhone() {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (phoneController.text.length == 0) {
      errorText = 'Please enter mobile number';
      update();
      return false;
    } else if (!regExp.hasMatch(phoneController.text)) {
      errorText = 'Please enter valid mobile number';
      update();
      return false;
    } else {
      return true;
    }
  }


  verifyOTP() async {
    print(phoneController.text);
    print('country code $countryCode');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${countryCode + phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        global.hideLoader();
        print('exception $e');

        global.showToast(
          message: 'Please enter valid mobile number',
          textColor: global.textColor,
          bgColor: global.toastBackGoundColor,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationId = verificationId;
        update();
        global.hideLoader();
        LoginController loginController = Get.find<LoginController>();
        loginController.timer();
        Get.to(() => VerifyPhoneScreen(
              phoneNumber: phoneController.text,
              verificationId: verificationId,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  loginAndSignupUser(int phoneNumber) async {
    try {
      await global.getDeviceData();
      LoginModel loginModel = LoginModel();
      loginModel.contactNo = phoneNumber.toString();
      loginModel.countryCode = countryCode.toString();
      loginModel.deviceInfo = DeviceInfoLoginModel();
      loginModel.deviceInfo!.appId = global.appId;
      loginModel.deviceInfo!.appVersion = global.appVersion;
      loginModel.deviceInfo!.deviceId = global.deviceId;
      loginModel.deviceInfo!.deviceLocation = global.deviceLocation ?? "";
      loginModel.deviceInfo!.deviceManufacturer = global.deviceManufacturer;
      loginModel.deviceInfo!.deviceModel = global.deviceManufacturer;
      loginModel.deviceInfo!.fcmToken = global.fcmToken;
      loginModel.deviceInfo!.appVersion = global.appVersion;

      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.loginSignUp(loginModel).then((result) async {
            if (result.status == "200") {
              var recordId = result.recordList["recordList"];
              var token = result.recordList["token"];
              var tokenType = result.recordList["token_type"];
              await global.saveCurrentUser(recordId["id"], token, tokenType);
              await splashController.getCurrentUserData();
              await global.getCurrentUser();
              print('success');
              global.hideLoader();
              HomeController homeController = Get.find<HomeController>();
              homeController.myOrders.clear();
              bottomController.setIndex(0, 0);
              Get.off(() => BottomNavigationBarScreen(index: 0));
            } else {
              global.hideLoader();
              log("what\'s wrong ${result.status}");

              global.showToast(
                message: 'Failed to sign in',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      global.hideLoader();
      print("Exception in loginAndSignupUser():-" + e.toString());
    }
  }
}
