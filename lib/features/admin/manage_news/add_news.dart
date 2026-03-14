import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../utils/colors.dart';
import '../../auth/presentation/widgets/auth_widgets.dart';
import '../../homepage/data/model/news_item_model.dart';
import '../../homepage/presentations/cubit/news_cubit.dart';

class AddNewsPage extends StatelessWidget {
  const AddNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.jonquil,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add News Post'.tr(context),
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          // leading: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        body: const AddNewsForm(),
      ),
    );
  }
}

class AddNewsForm extends StatefulWidget {
  const AddNewsForm({super.key});

  @override
  State<AddNewsForm> createState() => _AddNewsFormState();
}

class _AddNewsFormState extends State<AddNewsForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController priorityController = TextEditingController(
    text: "normal",
  );

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledInputFields(
            label: 'News Title'.tr(context),
            hint: "Enter a catchy title for the news post".tr(context),
            prefixIcon: Icons.title,
            controller: titleController,
          ),
          const SizedBox(height: 20),
          LabeledInputFields(
            label: 'News Description'.tr(context),
            hint:
                "Write a detailed description of the news post content and its objectives"
                    .tr(context),
            prefixIcon: Icons.description,
            controller: descriptionController,
            maxLines: 5,
          ),
          LabeledInputFields(
            label: 'News Link'.tr(context),
            hint: "Enter the link to the news post".tr(context),
            prefixIcon: Icons.description,
            controller: linkController,
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          Text(
            "Select priority".tr(context),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildDropdown(context),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              GetIt.I<NewsCubit>().addNewsItem(
                news: NewsItemModel(
                  title: titleController.text,
                  description: descriptionController.text,
                  link: linkController.text,
                  priority: priorityController.text,
                  date: DateTime.now().toIso8601String(),
                ),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("News post added successfully".tr(context)),
                  backgroundColor: AppColors.emerald,
                ),
              );
            },
            child: Text("Add News Post".tr(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            "Select priority".tr(context),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: AppColors.grey),
          ),
          value: priorityController.text,
          items: [
            DropdownMenuItem(value: 'high', child: Text('High'.tr(context))),
            DropdownMenuItem(
              value: 'normal',
              child: Text('Normal'.tr(context)),
            ),
          ], // Add your course list here
          onChanged: (v) => {priorityController.text = v ?? "normal"},
          // context.read<NewsCubit>().addNewsItem(v),
        ),
      ),
    );
  }
}
