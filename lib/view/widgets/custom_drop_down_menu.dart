import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../constants.dart';

class CustomDropdwonMenu extends StatelessWidget {
  const CustomDropdwonMenu({
    super.key,
    required this.hint,
    required this.dropdownHeight,
    // this.label,
    // this.value,
    this.borderColor,
    required this.options, this.onOptionSelected, this.controller,
  });

  final Color? borderColor;
  final String hint;
  final double? dropdownHeight;
  final List<ValueItem<dynamic>> options;
  final void Function(List<ValueItem<dynamic>>)? onOptionSelected;
  final MultiSelectController? controller;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: MultiSelectDropDown(
        // inputDecoration:,
        controller: controller,
        borderColor: borderColor,
        hint: hint,
        suffixIcon: const Icon(
          IconlyBroken.arrow_down_2,
        ),
        hintStyle: const TextStyle(fontSize: 15, color: Color(0xff9FA5C0)),
        onOptionSelected: onOptionSelected,
        options: options,
        selectionType: SelectionType.single,
        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
        dropdownHeight: dropdownHeight!,
        selectedOptionIcon: const Icon(
          Icons.check_circle,
          color: primary,
        ),
        borderWidth: 1,
        optionTextStyle: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: textColor, fontWeight: FontWeight.normal),
      ),
    );
  }
}
