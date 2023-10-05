import 'package:AstroGuru/controllers/bottomNavigationController.dart';
import 'package:AstroGuru/controllers/homeController.dart';
import 'package:AstroGuru/controllers/loginController.dart';
import 'package:AstroGuru/controllers/search_controller.dart';
import 'package:AstroGuru/views/bottomNavigationBarScreen.dart';
import 'package:AstroGuru/views/homeScreen.dart';
import 'package:AstroGuru/views/settings/privacyPolicyScreen.dart';
import 'package:AstroGuru/views/settings/termsAndConditionScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final LoginController loginController = Get.find<LoginController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.back();
        Get.back();
        print('call on will pop');
        SystemNavigator.pop();
        //exit(0);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height * 0.35,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.find<SearchController>().serachTextController.clear();
                              Get.find<SearchController>().searchText = '';
                              homeController.myOrders.clear();
                              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                              bottomNavigationController.setIndex(0, 0);
                              Get.off(() => BottomNavigationBarScreen(index: 0));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Skip",
                                textAlign: TextAlign.end,
                                style: Get.textTheme.subtitle1!.copyWith(color: Colors.black, decoration: TextDecoration.underline),
                              ).translate(),
                            ),
                          ),
                        ),
                      ),

                      CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/splash.png'),
                      ),
                      Text(
                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
                        style: Get.textTheme.headline5,
                      ).translate(),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Container(
                    width: Get.width,
                    height: Get.height - Get.height * 0.39,
                    color: Get.theme.primaryColor,
                    child: Stack(clipBehavior: Clip.none, children: [
                      Positioned(
                        top: -25,
                        left: 0,
                        right: 0,
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black54), borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                            child: Text('First Chat With Astrologer is FREE!', style: Get.textTheme.subtitle1!.copyWith(color: Colors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center).translate(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 0,
                        left: 0,
                        child: GetBuilder<LoginController>(builder: (loginController) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        child: FutureBuilder(
                                            future: global.translatedText("Phone Number"),
                                            builder: (context, snapshot) {
                                              return IntlPhoneField(
                                                autovalidateMode: null,
                                                showDropdownIcon: false,
                                                controller: loginController.phoneController,
                                                decoration: InputDecoration(
                                                    //labelText: 'Phone Number',
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    hintText: snapshot.data ?? 'Phone Number',
                                                    border: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    disabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    errorBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    errorText: null,
                                                    counterText: ''),
                                                initialCountryCode: 'IN',
                                                onChanged: (phone) {
                                                  //print(phone.completeNumber);
                                                  loginController.updateCountryCode(phone.countryCode);
                                                },
                                              );
                                            })),
                                  ),
                                ),
                              ),
                              GestureDetector(
                              //  onTap:()async{
                                //  print("LOgin user without token");
                               //   Get.to(HomeScreen());
                         // },
                                onTap: () async {
                                  bool isValid = loginController.validedPhone();
                                  if (isValid) {
                                    global.showOnlyLoaderDialog(context);
                                    await loginController.verifyOTP();
                                  } else {
                                    global.showToast(
                                      message: loginController.errorText!,
                                      textColor: global.textColor,
                                      bgColor: global.toastBackGoundColor,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                  child: Container(
                                    height: 45,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'SEND OTP',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ).translate(),
                                        Image.asset(
                                          'assets/images/arrow_left.png',
                                          color: Colors.white,
                                          width: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  child: Row(children: [
                                    Text(
                                      'By signing up, you agree to our ',
                                      style: TextStyle(color: Colors.grey, fontSize: 11),
                                    ).translate(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => TermAndConditionScreen());
                                      },
                                      child: Text(
                                        'Terms of use',
                                        style: TextStyle(decoration: TextDecoration.underline, fontSize: 11, color: Colors.blue),
                                      ).translate(),
                                    ),
                                    Text(' and ', style: TextStyle(color: Colors.grey, fontSize: 11)).translate(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => PrivacyPolicyScreen());
                                      },
                                      child: Text(
                                        ' Privacy',
                                        style: TextStyle(decoration: TextDecoration.underline, fontSize: 11, color: Colors.blue),
                                      ).translate(),
                                    ),
                                  ]),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => PrivacyPolicyScreen());
                                },
                                child: Text(
                                  'Policy',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 11,
                                    color: Colors.blue,
                                  ),
                                ).translate(),
                              ),
                            ],
                          );
                        }),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Get.theme.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '100%',
                                          style: Get.textTheme.headline6,
                                        ),
                                        Text(
                                          'privacy',
                                          style: TextStyle(fontSize: 12),
                                        ).translate()
                                      ],
                                    ),
                                    VerticalDivider(
                                      color: Colors.black,
                                      width: 20,
                                      thickness: 1,
                                      indent: 20,
                                      endIndent: 0,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '3000+',
                                          style: Get.textTheme.headline6,
                                        ),
                                        Text(
                                          'Top astrologers of',
                                          style: TextStyle(fontSize: 12),
                                        ).translate(),
                                        Text(
                                          'India',
                                          style: TextStyle(fontSize: 12),
                                        ).translate()
                                      ],
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: VerticalDivider(
                                        color: Colors.black,
                                        width: 20,
                                        thickness: 1,
                                        indent: 20,
                                        endIndent: 0,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '3Cr+',
                                          style: Get.textTheme.headline6,
                                        ),
                                        Text(
                                          'Happy',
                                          style: TextStyle(fontSize: 12),
                                        ).translate(),
                                        Text(
                                          'Customers',
                                          style: TextStyle(fontSize: 12),
                                        ).translate()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
