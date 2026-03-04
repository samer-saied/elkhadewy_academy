import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../utils/colors.dart';
import '../../courses/presentations/cubit/course_cubit.dart';

class ManageCoursesPage extends StatefulWidget {
  const ManageCoursesPage({super.key});

  @override
  State<ManageCoursesPage> createState() => _ManageCoursesPageState();
}

class _ManageCoursesPageState extends State<ManageCoursesPage> {
  final _cubit = GetIt.I<CourseCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchCourseItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Manage Courses'.tr(context),
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<CourseCubit, CourseState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CourseLoaded) {
            if (state.items.isEmpty) {
              return Center(child: Text("No Courses found".tr(context)));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(state.items[index].id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _cubit.deleteCourseItem(state.items[index].id.toString());
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: AppColors.whiteColor,
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.editCourse,
                          arguments: state.items[index],
                        );
                      },
                      tileColor: AppColors.whiteColor,
                      leading:
                          state.items[index].imgLink == null ||
                              state.items[index].imgLink!.isEmpty
                          ? Image.asset(
                              "assets/logo/logo_light.jpg",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              state.items[index].imgLink!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                      title: Text(
                        state.items[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "${"College".tr(context)}:${state.items[index].collegeTitle} - ${"Year".tr(context)}:${state.items[index].yearId}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Courses found".tr(context)));
        },
      ),
    );
  }
}



// Card(
//                     color: AppColors.whiteColor,
//                     child: Row(
//                       children: [
//                         Image.network(
//                           state.items[index].imgLink ?? "",
//                           width: 70,
//                           height: 70,
//                           fit: BoxFit.cover,
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               state.items[index].title,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               state.items[index].description,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text("College: ${state.items[index].collegeId}"),
//                             Text("Year: ${state.items[index].yearId}"),
//                             // Row(
//                             //   children: [
//                             //     IconButton(
//                             //       icon: Icon(Icons.edit),
//                             //       onPressed: () {
//                             //         Navigator.pushNamed(
//                             //           context,
//                             //           AppRoutes.editCourse,
//                             //           arguments: state.items[index],
//                             //         ).then((_) {
//                             //           // Re-fetch when returning from EditCoursesPage
//                             //           _cubit.fetchCourseItems();
//                             //         });
//                             //       },
//                             //     ),
//                             //     IconButton(
//                             //       icon: Icon(Icons.delete),
//                             //       onPressed: () {
//                             //         _cubit.deleteCourseItem(
//                             //           state.items[index].id.toString(),
//                             //         );
//                             //       },
//                             //     ),
//                             //   ],
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),