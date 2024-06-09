import 'dart:io';

import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:book_bridge/view/widgets/custom_app_bar.dart';
import 'package:custom_calender_picker/custom_calender_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../constants.dart';
import '../../../controllers/city_controller.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drop_down_menu.dart';
import '../../widgets/custom_text_fild_add_donation.dart';

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final DonationController donationController =  Get.find<DonationController>();
  // final DonationController donationController = Get.put(DonationController());
  final CityController cityController = Get.put(CityController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<File> selectedImages = []; // List of selected image
  final picker = ImagePicker();

  final TextEditingController _dateController = TextEditingController();
  final MultiSelectController _exchangePointController =
  MultiSelectController();
  final MultiSelectController _levelController = MultiSelectController();
  final MultiSelectController _semesterController = MultiSelectController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();

  List<DateTime> eachDateTime = [];
  DateTimeRange? rangeDateTime;

  String? selectedCity;
  List<ValueItem> exchangePointOptions = [];

  Future<void> getImages() async {
    if (selectedImages.length >= 6) {
      _showDialog('يمكنك اختيار 6 صور فقط');
      return;
    }

    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFiles.isNotEmpty) {
      if (pickedFiles.length + selectedImages.length > 6) {
        _showDialog('يمكنك اختيار 6 صور فقط');
      } else {
        setState(() {
          selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
        });
      }
    } else {
      _showDialog('لم يتم اختيار أي صور');
    }
  }

  void _showDialog(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Dialogs.bottomMaterialDialog(
        msg: message,
        context: context,
      );
    });
  }

  Widget _buildTextField(String label, String hint,
      {int maxLines = 1,
        TextEditingController? controller,
        bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(height: 20.h),
        CustomTextFieldAddDonation(
          hint: hint,
          maxLine: maxLines,
          controller: controller,
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          }
              : null,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDropDown(String label, String hint, List<ValueItem> options,
      {double dropdownHeight = 180,
        bool isRequired = false,
        MultiSelectController? controller,
        void Function(List<ValueItem<dynamic>>)? onOptionSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(height: 20.h),
        CustomDropdwonMenu(
          controller: controller,
          hint: hint,
          options: options,
          dropdownHeight: dropdownHeight,
          borderColor: outline,
          // validator: isRequired
          //     ? (value) {
          //   if (value == null) {
          //     return 'هذا الحقل مطلوب';
          //   }
          //   return null;
          // }
          //     : null,
          onOptionSelected: onOptionSelected,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDynamicDropDownExchangePoint() {
    return Obx(() {
      if (cityController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (exchangePointOptions.isEmpty && selectedCity != null) {
        // Check if there is no valid exchange point options and a city is selected
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDialog('لم يتم العثور على نقطة في الموقع الحالي');
        });
        return const SizedBox.shrink();
      } else if (exchangePointOptions.isEmpty) {
        return const SizedBox.shrink();
      }
      return _buildDropDown(
        "أسم النقطة",
        "أضف اسم النقطة",
        exchangePointOptions,
        isRequired: true,
        dropdownHeight: 90.h,
        controller: _exchangePointController,
      );
    });
  }

  Widget _buildDynamicDropDownCity() {
    return Obx(() {
      if (cityController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (cityController.citiesList.isEmpty) {
        _showDialog('لم يتم العثور على موقع');
        return const SizedBox.shrink();
      }
      List<ValueItem> options = cityController.citiesList
          .map((city) => ValueItem(label: city.name, value: city.id.toString()))
          .toList();
      return _buildDropDown(
        "الحي",
        "أضف الموقع بنسبة للحي",
        options,
        isRequired: false,
        onOptionSelected: (selectedOptions) {
          _exchangePointController.selectedOptions.clear();
          setState(() {
            selectedCity = selectedOptions.first.value.toString();
            exchangePointOptions = cityController.citiesList
                .firstWhere((city) => city.id.toString() == selectedCity)
                .exchangePoints
                .map((point) => ValueItem(
                label: point.account.userName, value: point.id.toString()))
                .toList();
          });
          setState(() {
            _exchangePointController.setOptions(exchangePointOptions);

          });
        },
      );
    });
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التاريخ",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(height: 20.h),
        InkWell(
          onTap: () async {
            var result = await showDialog(
              context: context,
              builder: (context) => Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(20).r),
                ),
                child: CustomCalenderPicker(
                  selectedColor: primary,
                  buttonColor: primary,
                  returnDateType: ReturnDateType.list,
                  initialDateList: eachDateTime,
                  calenderThema: CalenderThema.white,
                  buttonText: 'حفظ',
                ),
              ),
            );
            if (result != null && result is List<DateTime>) {
              setState(() {
                eachDateTime = result;
                _dateController.text = eachDateTime.isNotEmpty
                    ? eachDateTime
                    .map((date) => date.toLocal().toString().split(' ')[0])
                    .join(', ')
                    : '';
              });
            }
          },
          child: CustomTextFieldAddDonation(
            hint: "أضف التاريخ",
            controller: _dateController,
            enabled: false,
            icon: IconlyBroken.calendar,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _addCoverPhoto() {
    return DottedBorder(
      dashPattern: const [15, 5],
      color: outline,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.photo,
                size: 65,
                color: Colors.grey,
              ),
              Text(
                "أضف صورة للحزمة",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewImage() {
    return SizedBox(
      height: 200, // Define the height of the SizedBox
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                // Horizontally only 3 images will show
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      Image.file(
                        selectedImages[index],
                        width: 350,
                        height: 350,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              selectedImages.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            color: primary,
            textColor: form,
            text: "أضف صورة للحزمة",
            width: double.infinity,
            height: 40.h,
            onTap: () {
              getImages();
            },
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        int exchangePointId = int.parse(_exchangePointController.selectedOptions[0].value);
        String level = _levelController.selectedOptions[0].value.toString();
        String semester = _semesterController.selectedOptions[0].value.toString();
        String description = _descriptionController.text;
        String donorName = _donorNameController.text;

        bool success = await donationController.addDonation(
          exchangePointId: exchangePointId,
          level: level,
          semester: semester,
          description: description,
          donorName: donorName,
          images: selectedImages,
        );

        if (success) {
          _showDialog('تمت إضافة الحزمة بنجاح');
          Navigator.pop(context);
        } else {
          _showDialog('حدث خطأ أثناء إضافة الحزمة');
        }
      } catch (e) {
        print('Error parsing values: $e');
        _showDialog('حدث خطأ أثناء معالجة البيانات');
      }
    } else {
      _showDialog('يرجى ملء جميع الحقول المطلوبة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(title: "أضافة تبرع",),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          getImages();
                        },
                        child: selectedImages.isNotEmpty
                            ? _viewImage()
                            : _addCoverPhoto(),
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField("اسم المتبرع", "أضف اسم المتبرع",
                          isRequired: true, controller: _donorNameController),
                      _buildDropDown(
                        "السنة الدراسية",
                        "أضف السنه الدراسية للحزمة",
                        const <ValueItem>[
                          ValueItem(label: 'أولى إعدادي', value: 'أولى إعدادي'),
                          ValueItem(label: 'ثاني إعدادي', value: 'ثاني إعدادي'),
                          ValueItem(label: 'ثالث إعدادي', value: 'ثالث إعدادي'),
                          ValueItem(label: 'رابع إعدادي', value: 'رابع إعدادي'),
                          ValueItem(label: 'خامس إعدادي', value: 'خامس إعدادي'),
                          ValueItem(label: 'سادس إعدادي', value: 'سادس إعدادي'),
                          ValueItem(label: 'سابع إعدادي', value: 'سابع إعدادي'),
                          ValueItem(label: 'ثامن إعدادي', value: 'ثامن إعدادي'),
                          ValueItem(label: 'تاسع إعدادي', value: 'تاسع إعدادي'),
                          ValueItem(label: 'أولى ثانوي', value: 'أولى ثانوي'),
                          ValueItem(label: 'ثاني ثانوي', value: 'ثاني ثانوي'),
                          ValueItem(label: 'ثالث ثانوي', value: 'ثالث ثانوي'),
                        ],
                        isRequired: true,
                        controller: _levelController,
                      ),
                      _buildDropDown(
                        "الفصل الدراسي",
                        "أضف الفصل الدراسي للحزمة",
                        const <ValueItem>[
                          ValueItem(label: 'الفصل الأول', value: 'الفصل الأول'),
                          ValueItem(
                              label: 'الفصل الثاني', value: 'الفصل الثاني'),
                          ValueItem(label: 'كلا الفصلين', value: 'كلا الفصلين'),
                        ],
                        dropdownHeight: 140.h,
                        isRequired: true,
                        controller: _semesterController,
                      ),
                      _buildDynamicDropDownCity(),
                      _buildDynamicDropDownExchangePoint(),
                      // _buildDropDown(
                      //   "موقع الحزمة الحالي",
                      //   "أضف موقع الحزمة",
                      //   const <ValueItem>[
                      //     ValueItem(
                      //         label: 'الحزمة موجودة في النقطة بالفعل',
                      //         value: '1'),
                      //     ValueItem(
                      //         label: 'الحزمة غير موجودة في النقطة', value: '0'),
                      //   ],
                      //   dropdownHeight: 90.h,
                      //   isRequired: true,
                      // ),
                      _buildDatePicker(),
                      _buildTextField("الوصف", "أضف وصف قصير للحزمة",
                          maxLines: 4,
                          isRequired: false,
                          controller: _descriptionController),
                      SizedBox(height: 40.h),
                      CustomButton(
                        color: primary,
                        textColor: form,
                        text: "أضافة الحزمة",
                        width: double.infinity,
                        height: 55.h,
                        onTap: _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(() {
          if (donationController.isLoading.value) {
            return const LoadingOverlayHelper();
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

}
