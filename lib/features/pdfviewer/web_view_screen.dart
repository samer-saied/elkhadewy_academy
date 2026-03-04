// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mh_online/presentation/home/common/appbar.dart';
// import 'package:mh_online/presentation/single_course/widgets/copy_rights_widget.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../utils/colors.dart';

// class WebViewScreen extends StatefulWidget {
//   final String url;
//   final String name;
//   final String color;

//   const WebViewScreen(
//       {super.key, required this.url, required this.name, required this.color});

//   @override
//   WebViewScreenState createState() => WebViewScreenState();
// }

// class WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController controller;
//   bool isLoading = true;
//   final _key = UniqueKey();

//   @override
//   void initState() {
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             log(progress.toString());
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           // onUrlChange: (val) {
//           //   print(val.url);
//           //   if (val.url!.startsWith('https://drive.google.com/')) {
//           //     print("Yes");
//           //   } else {
//           //     Get.offAll(LogInScreen());
//           //   }
//           //   //  Get.back();
//           // },
//           onPageFinished: (String url) {
//             setState(() {
//               isLoading = false;
//             });
//           },
//           // onHttpError: (HttpResponseError error) {
//           //   Get.back();
//           //   getCustomDialog(
//           //       content: "Can't load PDF, Please try again later.",
//           //       title: "Error");
//           // },
//           onWebResourceError: (WebResourceError error) {
//             Get.back();
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://drive.google.com/')) {
//               return NavigationDecision.navigate;
//             }
//             return NavigationDecision.prevent;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppBar appTopWidget = mainAppBarWidget(
//         txt: widget.name,
//         barColor: AppColors.convertString2Color(
//             colorString: widget.color.toString()));
//     return Scaffold(
//       backgroundColor: AppColors.blackColor,
//       body: Stack(
//         children: [
//           WebViewWidget(
//             controller: controller,
//             key: _key,
//           ),
//           SizedBox(
//             height: appTopWidget.preferredSize.height +
//                 MediaQuery.of(context).padding.top/2,
//             child: appTopWidget,
//           ),
//           const CopyRigthsWidget(),
//           const CopyRigthsWidget(
//             isSafeArea: true,
//           ),
//           const CopyRigthsWidget(),
//           isLoading
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : const Stack(),
//         ],
//       ),
//     );
//   }
// }
