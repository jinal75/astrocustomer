import 'dart:io';

import 'package:AstroGuru/controllers/settings_controller.dart';
import 'package:AstroGuru/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Notifications',
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
            GetBuilder<SettingsController>(builder: (settingsController) {
              return settingsController.notification.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: '',
                            titlePadding: EdgeInsets.all(0),
                            content: Text('Are you sure you want to delete all notifications?').translate(),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            cancel: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(color: Get.theme.primaryColor),
                                ).translate()),
                            confirm: TextButton(
                                onPressed: () {
                                  global.showOnlyLoaderDialog(context);
                                  settingsController.deleteAllNotifications();
                                  global.hideLoader();
                                  Get.back();
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Get.theme.primaryColor),
                                ).translate()));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                        size: 18,
                      ));
            })
          ]),
      body: GetBuilder<SettingsController>(builder: (settingsController) {
        return settingsController.notification.isEmpty
            ? Center(
                child: Text('No Notifications Available').translate(),
              )
            : ListView.builder(
                itemCount: settingsController.notification.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(settingsController.notification[index].title!, style: Get.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                    title: '',
                                    titlePadding: EdgeInsets.all(0),
                                    content: Text('Are you sure you want to delete  notifications?').translate(),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                    cancel: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(color: Get.theme.primaryColor),
                                        ).translate()),
                                    confirm: TextButton(
                                        onPressed: () {
                                          global.showOnlyLoaderDialog(context);
                                          settingsController.deleteNotifications(settingsController.notification[index].id!);
                                          global.hideLoader();
                                          Get.back();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(color: Get.theme.primaryColor),
                                        ).translate()));
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        Text(
                          settingsController.notification[index].description!,
                          style: Get.textTheme.bodySmall,
                        ).translate(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(DateConverter.dateTimeStringToDateOnly('${settingsController.notification[index].createdAt!}'), style: Get.textTheme.bodySmall!.copyWith(fontSize: 10, color: Colors.grey)),
                        )
                      ]),
                    ),
                  );
                });
      }),
    );
  }
}
