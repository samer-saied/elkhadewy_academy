import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_info.dart';
import '../../../utils/colors.dart';
import '../../general/widgets/headers_widgets.dart';

class ContactMeScreen extends StatefulWidget {
  const ContactMeScreen({super.key});

  @override
  State<ContactMeScreen> createState() => _ContactMeScreenState();
}

class _ContactMeScreenState extends State<ContactMeScreen> {
  ///
  ///
  // WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;

  ///
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SectionHeaderSmallWidget(
          title: "Business Card".tr(context),
          color: AppColors.whiteColor,
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child:
                // WidgetsToImage(
                //   controller: controller,
                //   child:
                Container(
                  color: AppColors.whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Image.asset(AppInfo.logoPath),
                      ),
                      const Center(
                        child: Text(
                          AppInfo.infoName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Text(
                            AppInfo.infoDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.jonquil,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ContactWidget(
                              txt: AppInfo.infoPhone,
                              icon: Icons.phone,
                              colorCode: AppColors.blackColor,
                              uriCode: "tel:+${AppInfo.infoPhone}",
                            ),
                            ContactWidget(
                              txt: AppInfo.infoPhone,
                              icon: Icons.chat,
                              colorCode: AppColors.emerald,
                              uriCode: "https://wa.me/${AppInfo.infoPhone}",
                            ),
                            ContactWidget(
                              txt: AppInfo.infoFacebook,
                              icon: Icons.facebook,
                              colorCode: AppColors.mainColor,
                              uriCode: AppInfo.infoFacebook,
                            ),
                            ContactWidget(
                              txt: AppInfo.infoEMail,
                              icon: Icons.mail,
                              colorCode: AppColors.redWood,
                              uriCode: "mailto:${AppInfo.infoEMail}",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Text(
                          "Please let me know if you have any questions".tr(
                            context,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
            // ),
          ),
        ],
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  final IconData icon;
  final String txt;
  final Color colorCode;
  final String uriCode;
  const ContactWidget({
    super.key,
    required this.icon,
    required this.txt,
    required this.colorCode,
    required this.uriCode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(uriCode), mode: LaunchMode.externalApplication);
      },
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: colorCode, size: 22),
          title: Text(
            txt,
            style: TextStyle(
              fontSize: 16,
              color: colorCode,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
