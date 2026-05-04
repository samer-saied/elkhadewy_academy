import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/helper.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';
import '../../../course_details/data/chapter_model.dart';
import '../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../../../courses/presentations/cubit/course_cubit.dart';
import 'drop_down_widget.dart';

class AddEditChapterPage extends StatelessWidget {
  final Chapter? chapter;
  const AddEditChapterPage({super.key, this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          chapter == null
              ? 'Add New Chapter'.tr(context)
              : 'Edit Chapter'.tr(context),
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AddChapterForm(chapter: chapter),
    );
  }
}

class AddChapterForm extends StatefulWidget {
  final Chapter? chapter;
  const AddChapterForm({super.key, this.chapter});

  @override
  State<AddChapterForm> createState() => _AddChapterFormState();
}

class _AddChapterFormState extends State<AddChapterForm> {
  final _formKey = GlobalKey<FormState>();

  final _indexController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _linkController = TextEditingController();
  final List<TextEditingController> _attachmentControllers = [];

  String _selectedCourseId = '';

  @override
  void initState() {
    super.initState();
    _linkController.addListener(() => setState(() {}));
    GetIt.I<CourseCubit>().fetchCourseItems();

    if (widget.chapter != null) {
      final ch = widget.chapter!;
      _selectedCourseId = ch.courseId;
      _titleController.text = ch.title;
      _indexController.text = ch.orderIndex.toString();
      _contentController.text = ch.content;
      _linkController.text = ch.videoUrl;
      for (var attachment in ch.attachments) {
        _attachmentControllers.add(TextEditingController(text: attachment));
      }
    }
  }

  @override
  void dispose() {
    _indexController.dispose();
    _titleController.dispose();
    _linkController.dispose();
    _contentController.dispose();
    for (var controller in _attachmentControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // ignore: unnecessary_null_comparison
    if (_selectedCourseId == null || _selectedCourseId == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a course'),
          backgroundColor: AppColors.redWood,
        ),
      );
      return;
    }

    final chapter = Chapter(
      id: widget.chapter?.id,
      title: _titleController.text.trim(),
      orderIndex: int.tryParse(_indexController.text.trim()) ?? 0,
      content: _contentController.text.trim(),
      courseId: _selectedCourseId,
      createdAt: widget.chapter?.createdAt ?? Timestamp.now(),
      videoUrl: _linkController.text.trim(),
      createdBy:
          widget.chapter?.createdBy ?? GetIt.I<LoginCubit>().currentUser!.name,
      attachments: _attachmentControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
    );

    if (widget.chapter == null) {
      GetIt.I<ChaptersCubit>().addChapter(_selectedCourseId, chapter);
    } else {
      GetIt.I<ChaptersCubit>().updateChapter(_selectedCourseId, chapter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChaptersCubit, ChaptersState>(
      bloc: GetIt.I<ChaptersCubit>(),
      listener: (context, state) {
        if (state is ChaptersOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.emerald,
            ),
          );
          if (mounted) Navigator.of(context).pop();
        } else if (state is ChaptersFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.redWood,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order Index ──────────────────────────────────
                    LabeledInputFields(
                      label: 'Chapter Number',
                      hint: 'e.g. 1',
                      prefixIcon: Icons.numbers,
                      controller: _indexController,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Chapter number is required'
                          : (int.tryParse(v.trim()) == null)
                          ? 'Must be a valid number'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // ── Title ────────────────────────────────────────
                    LabeledInputFields(
                      label: 'Chapter Title',
                      hint: 'Enter a catchy title for the chapter',
                      prefixIcon: Icons.title,
                      controller: _titleController,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // ── Content / Description ────────────────────────
                    LabeledInputFields(
                      label: 'Chapter Description',
                      maxLines: 5,
                      hint:
                          'Write a detailed description of the chapter content and its objectives…',
                      controller: _contentController,
                      // validator: (v) => (v == null || v.trim().isEmpty)
                      //     ? 'Description is required'
                      //     : null,
                    ),
                    const SizedBox(height: 14),

                    // ── Course Dropdown ──────────────────────────────
                    Text(
                      'Select Course',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    /////////////////   DROPDOWN MENU WIDGET   ////////////////////////////
                    BuildCourseDropDown(
                      selectedCourseId: _selectedCourseId,
                      onChanged: (v) {
                        _selectedCourseId = v;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Video URL ────────────────────────────────────
                    LabeledInputFields(
                      label: 'YouTube Video URL',
                      maxLines: 1,
                      hint: 'https://www.youtube.com/watch?v=...',
                      prefixIcon: Icons.videocam_rounded,
                      controller: _linkController,
                      keyboardType: TextInputType.url,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Video URL is required'
                          : null,
                    ),
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: AppColors.jonquil,
                        strokeWidth: 1.5,
                        dashPattern: const [6, 3],
                        radius: const Radius.circular(15),
                      ),
                      child:
                          _linkController.text.isEmpty ||
                              Helper.extractYoutubeId(_linkController.text) ==
                                  null
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF9F0),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color(0xFFD49E3C),
                                    child: const Icon(
                                      Icons.videocam_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Input Chapter Video Youtube link".tr(
                                      context,
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFFD49E3C),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: YoutubePlayer(
                                controller: YoutubePlayerController(
                                  initialVideoId: Helper.extractYoutubeId(
                                    _linkController.text,
                                  ).toString(),
                                  flags: YoutubePlayerFlags(
                                    autoPlay: false,
                                    mute: true,
                                  ),
                                ),
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.amber,
                                progressColors: const ProgressBarColors(
                                  playedColor: Colors.amber,
                                  handleColor: Colors.amberAccent,
                                ),
                                onReady: () {},
                              ),
                            ),
                    ),
                    const SizedBox(height: 14),

                    // const SizedBox(height: 30),
                    _buildSectionHeader(
                      'Attachments',
                      Icons.attach_file,
                      onAdd: () {
                        setState(() {
                          _attachmentControllers.add(TextEditingController());
                        });
                      },
                    ),
                    ..._attachmentControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: LabeledInputFields(
                                label: 'Attachment Link ${index + 1}',
                                hint: 'Enter link here...',
                                prefixIcon: Icons.link,
                                controller: controller,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.dispose();
                                    _attachmentControllers.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 14),
                    // ── Save Button ──────────────────────────────────────────
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<ChaptersCubit, ChaptersState>(
      bloc: GetIt.I<ChaptersCubit>(),
      builder: (context, state) {
        final isLoading = state is ChaptersLoading;
        return Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: MaterialButton(
            onPressed: isLoading ? null : _submit,
            color: AppColors.jonquil,
            minWidth: double.infinity,
            height: 55,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: AppColors.jonquil)
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Publish Chapter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(Icons.rocket_launch, color: Colors.white),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// /////////////////   ATTACHMENTS //////////////////////////

Widget _buildSectionHeader(
  String title,
  IconData icon, {
  required VoidCallback onAdd,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(icon, color: const Color(0xFFD49E3C)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      TextButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add, size: 18, color: Color(0xFFD49E3C)),
        label: const Text(
          "Add File",
          style: TextStyle(color: Color(0xFFD49E3C)),
        ),
      ),
    ],
  );
}
