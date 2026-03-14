import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unimind/services/lang/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../utils/colors.dart';
import '../homepage/data/model/news_item_model.dart';

class SingleNewsPage extends StatelessWidget {
  final NewsItemModel singleNews;
  const SingleNewsPage({super.key, required this.singleNews});

  @override
  Widget build(BuildContext context) {
    // Get.locale!.languageCode == "ar"
    //     ? timeago.setLocaleMessages('ar', timeago.ArMessages())
    //     : timeago.setLocaleMessages('en', timeago.EnMessages());

    return Scaffold(
      appBar: AppBar(title: Text("News".tr(context))),

      body: SingleChildScrollView(child: getOnePost(context, singleNews)),
    );
  }

  Widget getOnePost(BuildContext context, NewsItemModel singleNews) {
    // Get.locale!.languageCode == "ar"
    //     ? timeago.setLocaleMessages('ar', timeago.ArMessages())
    //     : timeago.setLocaleMessages('en', timeago.EnMessages());
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            singleNews.title[0].toUpperCase() + singleNews.title.substring(1),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${"Priority".tr(context)} : ${singleNews.priority == null ? "normal" : singleNews.priority.toString().toUpperCase()}"
                " : ${singleNews.priority == null ? "normal" : singleNews.priority.toString().toUpperCase()}",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Icon(
                Icons.circle,
                size: 18,
                color: singleNews.priority == "high"
                    ? AppColors.redWood
                    : AppColors.emerald,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                singleNews.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (singleNews.date != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeago.format(DateTime.parse(singleNews.date!)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedLink02,
                  color: AppColors.jonquil,
                ),
                const SizedBox(width: 10),
                singleNews.link != null && singleNews.link != ""
                    ? TextButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.jonquil,
                          ),
                        ),
                        onPressed: () async {
                          var url = Uri.parse(singleNews.link!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.platformDefault,
                            );
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Center(
                          child: Text(
                            "Reference link ,Click Here".tr(context),
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.whiteColor),
                          ),
                        ),
                      )
                    : Text("No Reference".tr(context)),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
