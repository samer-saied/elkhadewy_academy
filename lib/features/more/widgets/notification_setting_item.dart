
// class NotificationSettingItem extends StatefulWidget {
//   final Color leadingIconColor;
//   final Color bgIconColor;
//   final Color txtIColor;
//   final String title;
//   final GestureTapCallback? onTap;
//   const NotificationSettingItem({
//     super.key,
//     required this.title,
//     this.onTap,
//     this.leadingIconColor = Colors.white,
//     this.txtIColor = Colors.black,
//     required this.bgIconColor,
//   });

//   @override
//   State<NotificationSettingItem> createState() =>
//       _NotificationSettingItemState();
// }

// class _NotificationSettingItemState extends State<NotificationSettingItem> {
//   NotificationUtils notificationUtils = NotificationUtils();
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // MainController mainController = Get.find<MainController>();
//     LocalStorage local = LocalStorage(GetStorage());
//     return Container(
//       padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration:
//               BoxDecoration(color: widget.bgIconColor, shape: BoxShape.circle),
//           child: Icon(
//             CupertinoIcons.bell_fill,
//             color: widget.leadingIconColor,
//           ),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: Text(
//             widget.title,
//             style: TextStyle(fontSize: 16, color: widget.txtIColor),
//           ),
//         ),
//         Switch(
//             value: local.readNotificationData(),
//             onChanged: (val) {
//               if (val) {
//                 notificationUtils.setPermissionsNotification();
//                 notificationUtils.createLocalNotification(
//                     titleTxt: "Mona Ellebody",
//                     bodyTxt: "Notifications' service is working");
//               } else {
//                 notificationUtils.cancelAllScheduledNotification();
//                 local.saveNotificationData(status: false);
//               }
//               setState(() {
//                 local.saveNotificationData(status: val);
//               });
//             })
//       ]),
//     );
//   }
// }
