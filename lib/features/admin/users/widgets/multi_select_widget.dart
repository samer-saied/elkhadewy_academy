import 'package:flutter/material.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../utils/colors.dart';
import '../../../courses/data/models/course_model.dart';

class MultiSelect extends StatefulWidget {
  final List<CourseModel> items;
  final List<String>? userItems;
  const MultiSelect({super.key, required this.items, required this.userItems});

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  // final List<String> _selectedItems = [];

  // This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        widget.userItems!.add(itemValue);
      } else {
        widget.userItems!.remove(itemValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: ListBody(
            children: widget.items
                .map(
                  (item) => CheckboxListTile(
                    activeColor: AppColors.jonquil,
                    value: widget.userItems!.contains(item.id),
                    title: Text(item.title),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) {
                      setState(() {
                        _itemChange(item.id.toString(), isChecked!);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
