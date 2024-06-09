import 'package:book_bridge/controllers/city_controller.dart';
import 'package:book_bridge/helper/loading_overlay_helper.dart';
import 'package:book_bridge/models/city_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';
import '../widgets/custom_Button.dart';
import '../widgets/custom_categories.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CityController _cityController = Get.find<CityController>();

  List<City> streetsAndItsPoints = [];
  bool isVisiblePoint = false;
  int isChecked = 0;
  String? selectedStreet;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedLevel;
  List level = [
    ['أولى إعدادي', false],
    ['ثاني إعدادي', false],
    ['ثالث إعدادي', false],
    ['رابع إعدادي', false],
    ['خامس إعدادي', false],
    ['سادس إعدادي', false],
    ['سابع إعدادي', false],
    ['ثامن إعدادي', false],
    ['تاسع إعدادي', false],
    ['أولى ثانوي', false],
    ['ثاني ثانوي', false],
    ['ثالث ثانوي', false],
  ];

  String? selectedSemester;
  List semester = [
    ['كلا الفصلين', false],
    ['الفصل الأول', false],
    ['الفصل الثاني', false],
  ];

  int? selectedStreetId;
  List<Map<String, dynamic>> streets = [];

  int? selectedPoint;
  List<Map<String, dynamic>> points = [];

  void toggleSelection(List list, int index) {
    setState(() {
      for (int i = 0; i < list.length; i++) {
        list[i][1] = false;
      }
      list[index][1] = !list[index][1];
    });
  }

  void levelSelected(int index) {
    toggleSelection(level, index);
    selectedLevel = level[index][1] ? level[index][0] : null;
  }

  void semesterSelected(int index) {
    toggleSelection(semester, index);
    selectedSemester = semester[index][1] ? semester[index][0] : null;
  }

  void streetSelected(int index) {
    setState(() {
      for (var street in streets) {
        street['isSelected'] = false;
      }
      streets[index]['isSelected'] = !streets[index]['isSelected'];
      selectedStreetId = streets[index]['isSelected'] ? streets[index]['id'] : null;
      isVisiblePoint = streets[index]['isSelected'];
      if (isVisiblePoint) getPoints(streets[index]['id']);
    });
  }

  void pointSelected(int index) {
    setState(() {
      for (var p in points) {
        p['isSelected'] = false;
      }
      points[index]['isSelected'] = !points[index]['isSelected'];
      selectedPoint = points[index]['isSelected'] ? points[index]['id'] : null;
    });
  }

  void getStreets() {
      streets = _cityController.citiesList
          .map((item) {
        return {
          'id': item.id,
          'name': item.name,
          'isSelected': false,
        };
      }).toList();
  }

  void getPoints(int id) {
    setState(() {
      points = [];
      setState(() {
        points = _cityController.citiesList
            .firstWhere((city) => city.id == id)
            .exchangePoints
            .map((point) {
          return {
            'id': point.id,
            'name': point.account.userName,
            'isSelected': false,
          };
        }).toList();
      });
    });
  }

  @override
  void initState() {
    getStreets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: form,
        ),
        backgroundColor: form,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            setState(() {
            });
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const SearchScreen();
                },
              ),
            );
          },
          icon: const Icon(Icons.restart_alt, color: mainText, size: 29),
        ),
        title: Text("البحث", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(IconlyBroken.arrow_right_2, color: primary, size: 29),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_cityController.isLoading.value)
            const LoadingOverlayHelper()
          else
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15).h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildCategorySelector("المستوى الدراسي", level, levelSelected),
                    _buildCategorySelector("الفصل الدراسي", semester, semesterSelected),
                    _buildCategorySelectorCityAndPoint("الحي", streets, streetSelected),
                    if (points.isNotEmpty)  // Check if points list is not empty
                      _buildCategorySelectorCityAndPoint("نقاط التسليم", points, pointSelected),
                    SizedBox(height: 20.h),
                    _buildCheckbox(),
                    SizedBox(height: 20.h),
                    Center(child: _buildSearchButton()),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(String title, List list, Function(int) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 50.h,
          margin: const EdgeInsets.symmetric(horizontal: 10).w,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomCategoriesList(
                      onTap: () => onTap(i),
                      text: list[i][0],
                      color: list[i][1] ? primary : form,
                      width: 130.w,
                      textColor: list[i][1] ? Colors.white : textColor,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelectorCityAndPoint(String title, List list, Function(int) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 50.h,
          margin: const EdgeInsets.symmetric(horizontal: 10).w,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomCategoriesList(
                      onTap: () => onTap(i),
                      text: list[i]['name'],
                      color: list[i]['isSelected']
                          ? primary
                          : form,
                      width: 130.w,
                      textColor: list[i]['isSelected']
                          ? Colors.white
                          : textColor,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5).w,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Checkbox(
              activeColor: primary,
              value: isChecked == 1,
              onChanged: (newValue) {
                setState(() {
                  isChecked = newValue! ? 1 : 0;
                });
              },
            ),
            Text("الحزمة موجودة في النقطة", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: mainText, fontSize: 15.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).w,
      child: CustomButton(
        color: primary,
        textColor: Colors.white,
        text: "بحث",
        width: 200,
        height: 50,
        onTap: () {
          Map<String, dynamic> searchData = {
            'level': selectedLevel,
            'semester': selectedSemester,
            'exchangePoint_id': selectedPoint,
            'inPoint': isChecked,
            'residentialQuarter_id': selectedStreetId
          };
          // print('Hello this is the input$searchData');
          Get.to(() => SearchResultScreen(searchData: searchData));
        },
      ),
    );
  }

}
