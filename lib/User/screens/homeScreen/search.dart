// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/models/user_models/search_model.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/User/screens/shimmer_loader/favourite_loader.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  final ApiHelper apiHelper = ApiHelper();
  LikeContro likecontro = Get.find();

  bool isLoading = false;
  SearchModel model = SearchModel();

  Future<void> searchApi(String xyz) async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse(apiHelper.search);
    var request = http.MultipartRequest('POST', uri);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Authorization': "Bearer $authToken",
    };

    request.headers.addAll(headers);

    request.fields['service_name'] = xyz;

    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    model = SearchModel.fromJson(userData);

    if (model.status == true) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Search"),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: Column(
          children: [
            sizeBoxHeight(10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    sizeBoxHeight(15),
                    searchBar(),
                    sizeBoxHeight(15),
                    allstore(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 0,
      child: TextField(
        controller: searchController,
        cursorColor: themeContro.isLightMode.value
            ? Appcolors.appPriSecColor.appPrimblue
            : Appcolors.white,
        onChanged: searchApi,
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w500,
        ),
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? const Color(0xffF3F3F3)
              : Appcolors.darkGray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Appcolors.appPriSecColor.appPrimblue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeContro.isLightMode.value
                  ? Appcolors.grey300
                  : Appcolors.darkGray,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: languageController.textTranslate("Search Store"),
          hintStyle: poppinsFont(13, Appcolors.grey400, FontWeight.w500),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 15, top: 15),
            child: Image.asset(
              AppAsstes.search,
              color: Appcolors.grey400,
              height: 10,
            ),
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
    );
  }

  Widget allstore() {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the maxCrossAxisExtent based on the screen width
    double maxCrossAxisExtent =
        screenWidth / 2; // You can adjust this value as needed

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Column(
      children: [
        searchController.text.isEmpty
            ? searchempty()
            : isLoading
            ? wishListLoader(context)
            : model.serviceSearch!.isEmpty
            ? searchempty()
            : GridView.builder(
                itemCount: model.serviceSearch!.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items in a row
                  childAspectRatio: 0.58, // Adjust for image and text ratio
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return CommanScreen(
                    lat: model.serviceSearch![index].lat ?? "0.0",
                    lon: model.serviceSearch![index].lon ?? "0.0",
                    storeImages: model.serviceSearch![index].serviceImages![0]
                        .toString(),
                    sname: model
                        .serviceSearch![index]
                        .serviceName!
                        .capitalizeFirst
                        .toString(),
                    cname: model
                        .serviceSearch![index]
                        .categoryName!
                        .capitalizeFirst
                        .toString(),
                    vname: model.serviceSearch![index].vendorFirstName
                        .toString(),
                    vendorImages: model.serviceSearch![index].vendorImage
                        .toString(),
                    isfeatured: model.serviceSearch![index].isFeatured ?? 0,
                    ratingCount:
                        model.serviceSearch![index].totalAvgReview!.isNotEmpty
                        ? double.parse(
                            model.serviceSearch![index].totalAvgReview!,
                          )
                        : 0,
                    avrageReview: model.serviceSearch![index].totalReviewCount!
                        .toString(),
                    isLike: userID.isEmpty
                        ? 0
                        : model.serviceSearch![index].isLike!,
                    onTaplike: () {
                      if (userID.isEmpty) {
                        snackBar('Please login to like this service');
                        loginPopup(bottomsheetHeight: Get.height * 0.95);
                      } else {
                        likecontro.likeApi(
                          model.serviceSearch![index].id.toString(),
                        );

                        // Toggle the isLike value for the UI update (you may want to update this dynamically after the API call succeeds)
                        setState(() {
                          model.serviceSearch![index].isLike =
                              model.serviceSearch![index].isLike == 0 ? 1 : 0;
                        });
                      }

                      // Call the API to like/unlike the service
                    },
                    onTapstore: () {
                      Get.to(
                        Details(
                          serviceid: model.serviceSearch![index].id.toString(),
                          isVendorService: false,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    location: model.serviceSearch![index].address.toString(),
                    price: model.serviceSearch![index].priceRange.toString(),
                  );
                },
              ).paddingSymmetric(horizontal: 20),
      ],
    );
  }

  Widget searchempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizeBoxHeight(170),
          SizedBox(
            height: 100,
            child: Image.asset(AppAsstes.emptyImage, width: 200, height: 180),
          ),
          label(
            languageController.textTranslate("No Data Found"),
            fontSize: 15,
            textColor: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
