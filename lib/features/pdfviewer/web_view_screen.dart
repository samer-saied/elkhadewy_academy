import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/colors.dart';
import '../single_chapter_view/widgets/copy_right_widget.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log(progress.toString());
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          // onUrlChange: (val) {
          //   print(val.url);
          //   if (val.url!.startsWith('https://drive.google.com/')) {
          //     print("Yes");
          //   } else {
          //     Get.offAll(LogInScreen());
          //   }
          //   //  Get.back();
          // },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          // onHttpError: (HttpResponseError error) {
          //   Get.back();
          //   getCustomDialog(
          //       content: "Can't load PDF, Please try again later.",
          //       title: "Error");
          // },
          onWebResourceError: (WebResourceError error) {
            Navigator.pop(context);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://drive.google.com/')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appTopWidget = AppBar(
      title: const Text('PDF Viewer'),
      backgroundColor: AppColors.jonquil,
    );

    return Scaffold(
      backgroundColor: AppColors.jonquil,

      body: Stack(
        children: [
          WebViewWidget(controller: controller, key: _key),
          Container(
            height: appTopWidget.preferredSize.height + 10,
            width: double.infinity,
            color: AppColors.jonquil,
            child: appTopWidget,
          ),
          // const CopyRigthsWidget(),
          const CopyRigthsWidget(isSafeArea: true),
          const CopyRigthsWidget(color: AppColors.jonquil, isSafeArea: true),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : const Stack(),
        ],
      ),
    );
  }
}
