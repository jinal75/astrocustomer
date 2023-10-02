import 'dart:io';

import 'package:AstroGuru/controllers/loginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;
  VerifyPhoneScreen({Key? key, required this.phoneNumber, required this.verificationId}) : super(key: key);
  final LoginController loginController = Get.find<LoginController>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromARGB(255, 245, 235, 235),
        title: Text(
          'Verify Phone',
          style: Get.textTheme.subtitle1,
        ).translate(),
        leading: IconButton(
            onPressed: () {
              Get.delete<LoginController>(force: true);
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      backgroundColor: Color.fromARGB(255, 245, 235, 235),
      body: Center(
        child: SizedBox(
          width: Get.width - Get.width * 0.1,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Text(
                  'OTP Send to ${loginController.countryCode}-$phoneNumber',
                  style: TextStyle(color: Colors.green),
                ).translate(),
                SizedBox(
                  height: 30,
                ),
                OtpTextField(
                  numberOfFields: 6,
                  showFieldAsBox: true,
                  onCodeChanged: (value) {},
                  onSubmit: (value) {
                    loginController.smsCode = value;
                    loginController.update();
                    print('smscode from : ${loginController.smsCode}');
                  },
                  filled: true,
                  fillColor: Colors.white,
                  fieldWidth: 48,
                  borderColor: Colors.transparent,
                  enabledBorderColor: Colors.transparent,
                  focusedBorderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  margin: EdgeInsets.only(right: 4),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: loginController.smsCode,
                        );
                        print('validation id${loginController.verificationId}');
                        print('smscode ${loginController.smsCode}');
                        global.showOnlyLoaderDialog(context);
                        await auth.signInWithCredential(credential);
                        await loginController.loginAndSignupUser(int.parse(phoneNumber));
                      } catch (e) {
                        global.hideLoader();

                        global.showToast(
                          message: "OTP INVALID",
                          textColor: Colors.white,
                          bgColor: Colors.red,
                        );
                        print("Exception " + e.toString());
                      }
                    },
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.black),
                    ).translate(),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GetBuilder<LoginController>(builder: (c) {
                  return SizedBox(
                      child: loginController.maxSecond != 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Resend OTP Available in ${loginController.maxSecond} s',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                ).translate()
                              ],
                            )
                          : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                'Resend OTP Available',
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                              ).translate(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      loginController.maxSecond = 60;
                                      loginController.second = 0;
                                      loginController.update();
                                      loginController.timer();
                                      loginController.phoneController.text = phoneNumber;
                                      loginController.verifyOTP();

                                    },
                                    child: Text(
                                      'Resend OTP on SMS',
                                      style: TextStyle(color: Colors.black),
                                    ).translate(),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                                      backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                    ),
                                  ),
                                ],
                              )
                            ]));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
