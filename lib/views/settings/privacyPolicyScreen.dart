import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widget/commonAppbar.dart';
import 'package:AstroGuru/utils/global.dart' as global;

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Privacy Policy',
          )),
      body: WebView(
        initialUrl: '${global.webBaseUrl}privacyPolicy',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
