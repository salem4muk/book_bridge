import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_donation_container.dart';
import 'subject_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final Map<String, dynamic> searchData;

  const SearchResultScreen({super.key, required this.searchData});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final DonationController _donationController = Get.find<DonationController>();
  List<dynamic> donations = [];
  bool isLoading = true;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchDonations();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreDonations();
      }
    });
  }

  Future<void> _fetchDonations() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> fetchedDonations = await _donationController.searchAvailableBookPackages(currentPage,widget.searchData);
    setState(() {
      donations.addAll(fetchedDonations);
      isLoading = false;
    });
  }

  void _loadMoreDonations() {
    if (!isLoading) {
      setState(() {
        currentPage++;
      });
      _fetchDonations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "نتائج البحث"),
      body: Center(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: _buildDonationItems()
        ),
      ),

    );
  }

  Widget _buildDonationItems() {
    if (donations.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (donations.isEmpty) {
      return const Center(child: Text('لا توجد تبرعات متاحة.'));
    } else {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            ...donations.map((donation) {
              return InkWell(
                onTap: () {
                  Get.to(() => SubjectScreen(id: donation.id));
                },
                child: CustomDonationContainer(
                  level: donation.level,
                  semester: donation.semester,
                  pointName: donation.pointName,
                  donorName: donation.donorName ?? 'سالم ياسر',
                  isPoint: donation.isInPoint ?? 0 ,
                  date: donation.date,
                  residentialQuarter: donation.residentialQuarter,
                  location: donation.location,
                ),
              );
            }).toList(),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    }
  }
}
