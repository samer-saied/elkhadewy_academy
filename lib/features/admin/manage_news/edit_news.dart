import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../utils/colors.dart';
import '../../auth/presentation/widgets/auth_widgets.dart';
import '../../homepage/data/model/news_item_model.dart';
import '../../homepage/presentations/cubit/news_cubit.dart';

class EditNewsPage extends StatelessWidget {
  final NewsItemModel news;
  const EditNewsPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<NewsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.jonquil,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit News Post'.tr(context),
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          // leading: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        body: EditNewsForm(news: news),
      ),
    );
  }
}

class EditNewsForm extends StatefulWidget {
  final NewsItemModel news;
  const EditNewsForm({super.key, required this.news});

  @override
  State<EditNewsForm> createState() => _EditNewsFormState();
}

class _EditNewsFormState extends State<EditNewsForm> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController linkController;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    descriptionController = TextEditingController(
      text: widget.news.description,
    );
    linkController = TextEditingController(text: widget.news.link);
    _selectedPriority = widget.news.priority ?? 'normal';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
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
                "Write a detailed description of the news post content and its objectives..."
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
              GetIt.I<NewsCubit>().updateNewsItem(
                news: NewsItemModel(
                  id: widget.news.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  link: linkController.text,
                  priority: _selectedPriority,
                ),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("News post Edited successfully".tr(context)),
                  backgroundColor: AppColors.emerald,
                ),
              );
            },
            child: Text("Edit News Post".tr(context)),
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

          value: _selectedPriority,
          items: [
            DropdownMenuItem(value: 'high', child: Text('High'.tr(context))),
            DropdownMenuItem(
              value: 'normal',
              child: Text('Normal'.tr(context)),
            ),
          ],
          onChanged: (v) => setState(() => _selectedPriority = v ?? 'normal'),
          // context.read<NewsCubit>().addNewsItem(v),
        ),
      ),
    );
  }
}
