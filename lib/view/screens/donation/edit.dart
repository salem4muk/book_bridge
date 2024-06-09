import 'dart:io';

import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:book_bridge/helper/dialog_helper.dart';
import 'package:book_bridge/view/widgets/custom_app_bar.dart';
import 'package:custom_calender_picker/custom_calender_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../constants.dart';
import '../../../controllers/city_controller.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../../models/donation_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drop_down_menu.dart';
import '../../widgets/custom_text_fild_add_donation.dart';

class EditDonationScreen extends StatefulWidget {
  const EditDonationScreen({super.key, required this.id});

  @override
  State<EditDonationScreen> createState() => _EditDonationScreenState();
  final int id;
}

class _EditDonationScreenState extends State<EditDonationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<File> selectedImages = []; // List of selected image
  List<int> oldRemoveImages = []; // List of old remove image
  final picker = ImagePicker();

  final TextEditingController _dateController = TextEditingController();
  final MultiSelectController _exchangePointController =
      MultiSelectController();
  final MultiSelectController _levelController = MultiSelectController();
  final MultiSelectController _semesterController = MultiSelectController();
  final MultiSelectController _cityController = MultiSelectController();
  //final MultiSelectController _isPointController = MultiSelectController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();

  List<DateTime> eachDateTime = [];
  DateTimeRange? rangeDateTime;

  final CityController cityController = Get.put(CityController());
  final DonationController _donationController = Get.put(DonationController());
  String? selectedCity;
  String? selectedCityEdit;
  String? selectedExchangePointEdit;
  List<ValueItem> exchangePointOptions = [];
  List<ValueItem> options = [];

  Donation? donation;
  bool isLoading = true;
  int activeIndex = 0;

  Future<void> _getDonations() async {
    setState(() {
      isLoading = true;
    });
    donation = await _donationController.getDonation(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchDonations() async {
    if (donation != null) {
      selectedImages = donation!.images
          .map((image) => File(baseUrlPathImage + image.source))
          .toList();
      _dateController.text = donation!.date;
      _donorNameController.text = donation!.donorName ?? "";
      _descriptionController.text = donation!.description!;
      _levelController.setSelectedOptions(
          [ValueItem(label: donation!.level, value: donation!.level)]);
      _semesterController.setSelectedOptions(
          [ValueItem(label: donation!.semester, value: donation!.semester)]);
      selectedCityEdit = donation!.residentialQuarter;
      selectedExchangePointEdit = donation!.pointName;

      options = cityController.citiesList
          .map((city) => ValueItem(label: city.name, value: city.id.toString()))
          .toList();
      _cityController.setOptions(options);

      if (selectedCityEdit != null) {
        final matchingOption =
            options.firstWhereOrNull((city) => city.label == selectedCityEdit);
        if (matchingOption != null) {
          Future.microtask(
              () => _cityController.setSelectedOptions([matchingOption]));
        }
      }
      if (selectedExchangePointEdit != null) {
        Future.microtask(() => _exchangePointController.setSelectedOptions([
              exchangePointOptions.firstWhere((exchangePoint) =>
                  exchangePoint.label == selectedExchangePointEdit)
            ]));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getDonations();
    await _fetchDonations();
  }

  Future<void> getImages() async {
    if (selectedImages.length >= 6) {
      DialogHelper.showDialog('يمكنك اختيار 6 صور فقط');
      return;
    }

    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFiles.isNotEmpty) {
      if (pickedFiles.length + selectedImages.length > 6) {
        DialogHelper.showDialog('يمكنك اختيار 6 صور فقط');
      } else {
        setState(() {
          selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
        });
      }
    } else {
      DialogHelper.showDialog('لم يتم اختيار أي صور');
    }
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
          DialogHelper.showDialog('لم يتم العثور على نقطة في الموقع الحالي');
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
        DialogHelper.showDialog('لم يتم العثور على موقع');
        return const SizedBox.shrink();
      }

      return _buildDropDown(
        "الحي",
        "أضف الموقع بنسبة للحي",
        options,
        isRequired: false,
        controller: _cityController,
        onOptionSelected: (selectedOptions) {
          if (selectedOptions.isNotEmpty) {
            _exchangePointController.selectedOptions.clear();
            setState(() {
              selectedCity = selectedOptions.first.value.toString();
              exchangePointOptions = cityController.citiesList
                  .firstWhere((city) => city.id.toString() == selectedCity)
                  .exchangePoints
                  .map((point) => ValueItem(
                      label: point.account.userName,
                      value: point.id.toString()))
                  .toList();
            });
            setState(() {
              _exchangePointController.selectedOptions.clear();
              _exchangePointController.setOptions(exchangePointOptions);
            });
          }
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
                      selectedImages[index].path.contains('http')
                          ? Image.network(
                              selectedImages[index].path,
                              width: 350,
                              height: 350,
                              fit: BoxFit.fill,
                            )
                          : Image.file(
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
                              int id = donation!.images
                                  .firstWhere((image) =>
                                      baseUrlPathImage + image.source ==
                                      selectedImages[index].path)
                                  .id;
                              oldRemoveImages.add(id);
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

  void _submitForm(List<File> image) async {
    if (_formKey.currentState!.validate()) {
      int exchangePointId =
          int.parse(_exchangePointController.selectedOptions[0].value);
      String level = _levelController.selectedOptions[0].value.toString();
      String semester = _semesterController.selectedOptions[0].value.toString();
      String description = _descriptionController.text;
      String donorName = _donorNameController.text;

      await _donationController.editDonation(
        id: widget.id,
        exchangePointId: exchangePointId,
        level: level,
        semester: semester,
        description: description,
        donorName: donorName,
        images: image,
        deletedImages: oldRemoveImages,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            title: "أضافة تبرع",
          ),
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
                        text: "حفظ",
                        width: double.infinity,
                        height: 55.h,
                        onTap: () {
                          List<File> images = [];
                          for (File image in selectedImages) {
                            if (image.path.contains('http')) {
                              continue;
                            } else {
                              images.add(image);
                            }
                          }
                          _submitForm(images);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(() {
          if (_donationController.isLoading.value) {
            return const LoadingOverlayHelper();
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
