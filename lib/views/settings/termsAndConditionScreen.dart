import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:AstroGuru/utils/global.dart' as global;
import '../../widget/commonAppbar.dart';

class TermAndConditionScreen extends StatelessWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Terms and Condition',
          )),
      body: WebView(
        initialUrl: '${global.webBaseUrl}terms-condition',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
