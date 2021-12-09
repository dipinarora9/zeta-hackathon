import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zeta_hackathon/meta/metatexts.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (c) async =>
          await c.loadHtmlString(MetaTexts.btcChartWidget3),
      // data: MetaTexts.btcChartWidget2,
      // style:
      //     // {padding: 0px; margin: 0px; width: 100%;
      //     {
      //   // 'div': Style(
      //   //   height: 800,
      //   //   padding: EdgeInsets.zero,
      //   //   margin: EdgeInsets.zero,
      //   //   width: MediaQuery.of(context).size.width,
      //   // ),
      //   'iframe': Style(width: MediaQuery.of(context).size.width, height: 500),
      // },
    );
  }
}
