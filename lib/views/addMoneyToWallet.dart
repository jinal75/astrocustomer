import 'package:AstroGuru/controllers/razorPayController.dart';
import 'package:AstroGuru/controllers/splashController.dart';
import 'package:AstroGuru/controllers/walletController.dart';
import 'package:AstroGuru/model/businessLayer/baseRoute.dart';
import 'package:AstroGuru/utils/global.dart';
import 'package:AstroGuru/views/paymentInformationScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:AstroGuru/utils/global.dart' as global;

import '../widget/commonAppbar.dart';

class AddmoneyToWallet extends BaseRoute {
  AddmoneyToWallet({a, o}) : super(a: a, o: o, r: 'AddMoneyToWallet');
  final WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Add money to wallet',
          )),
      body: SingleChildScrollView(
        child: GetBuilder<SplashController>(builder: (splash) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.grey),
                ).translate(),
                Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${splashController.currentUser!.walletAmount.toString()}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                GetBuilder<WalletController>(builder: (c) {
                  return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 1.5,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: walletController.paymentAmount.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.delete<RazorPayController>();
                            Get.to(() => PaymentInformationScreen(
                                  amount: double.parse(walletController.paymentAmount[index].amount.toString()),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(child: Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}')),
                            ),
                          ),
                        );
                      });
                })
              ],
            ),
          );
        }),
      ),
    );
  }
}
