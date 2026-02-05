// ignore_for_file: prefer_const_constructors, unused_element, must_be_immutable, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, deprecated_member_use, unused_field, curly_braces_in_flow_control_structures, avoid_print, empty_catches, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:nlytical/User/screens/homeScreen/chat_screen2.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlytical/utils/image_slide_show/src/image_slideshow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nlytical/User/screens/review/store_review.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/add_review_contro.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/controllers/user_controllers/service_contro.dart';
import 'package:nlytical/models/user_models/service_detail_model.dart';
import 'package:nlytical/User/screens/homeScreen/sub_details.dart';
import 'package:nlytical/User/screens/shimmer_loader/details_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/google_map.dart';
import 'package:nlytical/utils/html_text_convert.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/video_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as parser;

class Details extends StatefulWidget {
  String? serviceid;
  bool isVendorService;

  Details({super.key, this.serviceid, required this.isVendorService});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  ServiceContro servicecontro = Get.find();
  AddreviewContro addreviewcontro = Get.find();
  LikeContro likecontro = Get.find();
  TextEditingController searchcontroller = TextEditingController();
  HomeContro homecontro = Get.find();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  late AnimationController _animationController;
  final GlobalKey _tabBarGlobalKey = GlobalKey(
    debugLabel: 'tabBar_${DateTime.now().millisecondsSinceEpoch}',
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(
    debugLabel: 'scaffold_${DateTime.now().millisecondsSinceEpoch}',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      servicecontro.servicedetailApi(
        serviceID: widget.serviceid!,
        isVendorService: widget.isVendorService,
      );

      // Tap and swipe both listener
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          _scrollToTabBar();
        }
      });

      _tabController.animation?.addListener(() {
        final value = _tabController.animation!.value;
        if (value == _tabController.index.toDouble()) {
          _scrollToTabBar();
        }
      });
    });
  }

  void _scrollToTabBar() async {
    await Future.delayed(Duration(milliseconds: 50));

    if (!mounted || !_scrollController.hasClients) return;

    // Fix 2: Use the renamed private key
    final context = _tabBarGlobalKey.currentContext;
    if (context == null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final tabBarPosition = renderBox.localToGlobal(Offset.zero).dy;
      final currentOffset = _scrollController.offset;

      await _scrollController.animateTo(
        currentOffset + tabBarPosition - kToolbarHeight,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchResult.clear();
    searchController.dispose();
    msgController.dispose();
    super.dispose();
  }

  String truncateText(String text, {int maxLength = 20}) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  final msgController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Duration? duration, position;
  bool isPlay = true;
  double videoProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Appcolors.appBgColor.transparent,
        statusBarIconBrightness: themeContro.isLightMode.value
            ? Brightness.dark
            : Brightness.light, // black icons
        statusBarBrightness: themeContro.isLightMode.value
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: themeContro.isLightMode.value
            ? Appcolors.appBgColor.white
            : Appcolors.appBgColor.darkMainBlack,
        bottomNavigationBar: Obx(() {
          return servicecontro.isservice.value
              ? SizedBox.shrink()
              : servicecontro.servicemodel.value!.vendor.toString() == userID
              ? SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkMainBlack,

                    // Background color of bottom navigation bar
                    boxShadow: !themeContro.isLightMode.value
                        ? [
                            BoxShadow(
                              color: Appcolors.black,
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: Offset(5, 5),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Appcolors.black.withValues(alpha: 0.11),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                  ),
                  child: BottomAppBar(
                    height: 70,
                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkMainBlack,
                    child: bottam(),
                  ),
                );
        }),
        // : SizedBox.shrink(),
        body: Obx(() {
          return servicecontro.isservice.value
              ? detailLoader(context)
              : DefaultTabController(
                  length: 4,
                  initialIndex: 0,
                  child: SafeArea(
                    top: true,
                    bottom: false,
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  imagelistt(),
                                  themeContro.isLightMode.value
                                      ? sizeBoxHeight(60)
                                      : sizeBoxHeight(70),
                                ]),
                              ),
                              SliverAppBar(
                                pinned: true,
                                floating: false,
                                backgroundColor: themeContro.isLightMode.value
                                    ? Appcolors.appBgColor.white
                                    : Appcolors.darkMainBlack,
                                elevation: 0,
                                scrolledUnderElevation: 0,
                                automaticallyImplyLeading: false,
                                toolbarHeight: 0,
                                bottom: PreferredSize(
                                  preferredSize: Size.fromHeight(50),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.appBgColor.white
                                          : Appcolors.darkMainBlack,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: ButtonsTabBar(
                                      key: _tabBarGlobalKey,
                                      backgroundColor:
                                          Appcolors.appPriSecColor.appPrimblue,
                                      borderColor:
                                          Appcolors.appPriSecColor.appPrimblue,
                                      unselectedBorderColor:
                                          themeContro.isLightMode.value
                                          ? Appcolors.appPriSecColor.appPrimblue
                                          : Appcolors.appTextColor.textLighGray,
                                      unselectedBackgroundColor:
                                          themeContro.isLightMode.value
                                          ? Appcolors.white
                                          : Appcolors.darkMainBlack,
                                      borderWidth: 1,
                                      height: getProportionateScreenHeight(45),
                                      controller: _tabController,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                      radius: 10,
                                      unselectedLabelStyle: TextStyle(
                                        color: themeContro.isLightMode.value
                                            ? Appcolors.black
                                            : Appcolors
                                                  .appTextColor
                                                  .textLighGray,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                      labelStyle: TextStyle(
                                        color: Appcolors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                      tabs: [
                                        Tab(text: 'Overview'),
                                        Tab(text: 'Services'),
                                        Tab(text: 'Photos'),
                                        Tab(text: 'Reviews'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          },

                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          info(),
                          services(),
                          photos(),
                          customerreview(),
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }

  int _currentIndex = 0;
  Widget _buildIndicators() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: servicecontro.servicemodel.value!.serviceDetail!.serviceImages!
          .asMap()
          .entries
          .map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = entry.key;
                });
              },
              child: Container(
                height: 9,
                width: 9,
                margin: const EdgeInsets.symmetric(
                  vertical: 3.0,
                ), // Adjusted for vertical spacing
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: entry.key == _currentIndex
                      ? Appcolors.white
                      : Appcolors.white,
                  border: Border.all(
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                ),
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(
                    vertical: 2.5,
                  ), // Adjusted for vertical spacing
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry.key == _currentIndex
                        ? Appcolors.appPriSecColor.appPrimblue
                        : Appcolors.appBgColor.transparent,
                    border: Border.all(
                      color: Appcolors.appPriSecColor.appPrimblue,
                    ),
                  ),
                ),
              ),
            );
          })
          .toList(),
    );
  }

  Widget _poster2(BuildContext context) {
    Widget carousel =
        servicecontro.servicemodel.value!.serviceDetail!.serviceImages!.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Appcolors.appPriSecColor.appPrimblue,
            ),
          )
        : Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: ImageSlideshow(
                  initialPage: 0,
                  autoPlayInterval: 3000,
                  isLoop:
                      servicecontro
                          .servicemodel
                          .value!
                          .serviceDetail!
                          .serviceImages!
                          .length >
                      1,
                  height: 310,
                  indicatorColor: Appcolors.appPriSecColor.appPrimblue,
                  indicatorBackgroundColor: Appcolors.white,
                  indicatorRadius: 3,
                  onPageChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  children: servicecontro
                      .servicemodel
                      .value!
                      .serviceDetail!
                      .serviceImages!
                      .map((img) {
                        return Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error,
                                color: Appcolors.appTextColor.textRedColor,
                              ),
                            );
                          },
                        );
                      })
                      .toList(),
                ),
              ),
            ],
          );

    return SizedBox(
      height: Get.height * 0.35,
      width: Get.width,
      child: carousel,
    );
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(imageUrl);
    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            final myImage = info.image;
            completer.complete(
              Size(myImage.width.toDouble(), myImage.height.toDouble()),
            );
          }),
        );
    return completer.future;
  }

  Widget posterDialog2(BuildContext context, int initialIndex) {
    List<String> images =
        servicecontro.servicemodel.value!.serviceDetail!.serviceImages!;
    String currentImageUrl = images[initialIndex];

    return FutureBuilder<Size>(
      future: _getImageSize(currentImageUrl),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Appcolors.appPriSecColor.appPrimblue,
            ),
          );
        }

        final imageSize = snapshot.data!;
        final isPortrait = imageSize.height > imageSize.width;

        double dialogWidth = isPortrait ? Get.width * 0.65 : Get.width * 0.90;
        double dialogHeight = isPortrait ? Get.height * 0.65 : Get.height * 0.5;

        return SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: ImageSlideshow(
            initialPage: initialIndex,
            autoPlayInterval: images.length > 1 ? 3000 : null,
            isLoop: images.length > 1,
            indicatorColor: Appcolors.appPriSecColor.appPrimblue,
            indicatorBackgroundColor: Appcolors.white,
            indicatorRadius: 3,
            children: images.map((img) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  img,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: Appcolors.appTextColor.textRedColor,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _launchWhatsapp(String url) async {
    url = url;
    //"https://wa.me/?text=Hey buddy, try this super cool new app!";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchWhatsapp(String phoneNumber) async {
    String whatsappUrl =
        "whatsapp://send?phone=$phoneNumber"; // Mobile WhatsApp
    String webWhatsappUrl =
        "https://web.whatsapp.com/send?phone=$phoneNumber"; // Web WhatsApp

    Uri uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      // Open WhatsApp app if installed
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Open WhatsApp Web if app is not available
      Uri webUri = Uri.parse(webWhatsappUrl);
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    }
  }

  void _launchSocial(
    String urll,
    //, String fallbackUrl
  ) async {
    //url = url;
    // 'fb://page/109225061600007','https://www.facebook.com/Username'
    // try {
    //   final Uri uri = Uri.parse(url);
    //   await launchUrl(uri, mode: LaunchMode.platformDefault);
    // } catch (e) {
    //   final Uri fallbackUri = Uri.parse(fallbackUrl);
    //   await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    // }
    var url = urll;
    //'fb://facewebmodal/f?href=https://www.facebook.com/al.mamun.me12';
    if (await canLaunch(url)) {
      await launch(url, universalLinksOnly: true);
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  String convertHtmlToText(String htmlString) {
    var document = parser.parse(htmlString);

    return document.body!.text;
  }

  Widget info() {
    bool hasAnySocialLink =
        servicecontro.servicemodel.value!.serviceDetail!.whatsappLink != "" ||
        servicecontro.servicemodel.value!.serviceDetail!.facebookLink != "" ||
        servicecontro.servicemodel.value!.serviceDetail!.instagramLink != "" ||
        servicecontro.servicemodel.value!.serviceDetail!.twitterLink != "";
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.appBgColor.white
            : Appcolors.appBgColor.darkMainBlack,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // *********************************** Business information *****************************************
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: Get.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appBgColor.white
                        : Appcolors.appBgColor.darkGray,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appShadowColor.cECECEC
                            : Appcolors.appShadowColor.darkShadowColor,
                        blurRadius: 14.0,
                        spreadRadius: 0.0,
                        offset: Offset(2.0, 4.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Information',
                          style: AppTypography.text14Medium(
                            context,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Container(
                          key: ValueKey('html_content_${widget.serviceid}'),
                          child: HtmlReadMoreView(
                            htmlData: cleanHtmlText(
                              servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .serviceDescription
                                  .toString(),
                            ),
                            trimLines: 3,
                            textColor: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 10),
            sizeBoxHeight(5),
            // *********************************** Business Address *****************************************
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.appBgColor.white
                    : Appcolors.appBgColor.darkGray,
                boxShadow: [
                  BoxShadow(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appShadowColor.cECECEC
                        : Appcolors.appShadowColor.darkShadowColor,
                    blurRadius: 14.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 4.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/location1.png',
                          height: 20,
                          color: themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.appPriSecColor.appPrimblue,
                        ),
                        sizeBoxWidth(5),
                        SizedBox(
                          width: Get.width * 0.70,
                          child: Text(
                            servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .address!
                                .toString(),
                            style: AppTypography.text12Medium(context),
                          ),
                        ),
                      ],
                    ),
                    sizeBoxHeight(5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            openGoogleMaps(
                              originLat: userLatitude,
                              originLong: userLongitude,
                              destLat: servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .lat!
                                  .toString(),
                              destLong: servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .lon!
                                  .toString(),
                            );
                          },
                          child: Container(
                            height: 22,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.appPriSecColor.appPrimblue
                                    : Appcolors.white,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Get Direction',
                                style: AppTypography.text8Medium(context)
                                    .copyWith(
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.appPriSecColor.appPrimblue
                                          : Appcolors.appTextColor.textWhite,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        sizeBoxWidth(8),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .address!
                                    .toString(),
                              ),
                            );
                            snackBar('Location Copied');
                          },
                          child: Container(
                            height: 22,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.appPriSecColor.appPrimblue
                                    : Appcolors.white,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Copy',
                                style: AppTypography.text8Medium(context)
                                    .copyWith(
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.appPriSecColor.appPrimblue
                                          : Appcolors.appTextColor.textWhite,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20),
                    sizeBoxHeight(15),
                    Text(
                      'Business Hours',
                      style: AppTypography.text10Medium(context).copyWith(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appTextColor.textBlack
                            : Appcolors.appPriSecColor.appPrimblue,
                      ),
                    ),
                    sizeBoxHeight(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${servicecontro.servicemodel.value!.serviceDetail!.openTime.toString()} to ${servicecontro.servicemodel.value!.serviceDetail!.closeTime.toString()}',
                          style: AppTypography.text10Medium(context),
                        ),
                        GestureDetector(
                          onTap: () {
                            _buisnessHour();
                          },
                          child: Row(
                            children: [
                              Text(
                                isBusinessOpen() ? 'Open Now' : 'Closed',
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color: isBusinessOpen()
                                          ? Color(0xff4CAF50)
                                          : Appcolors.appTextColor.textRedColor,
                                    ),
                              ),
                              sizeBoxWidth(5),
                              Image.asset(
                                'assets/images/arrow-left (1).png',
                                height: 13,
                                width: 13,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.appPriSecColor.appPrimblue
                                    : Appcolors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .serviceWebsite!
                            .isEmpty
                        ? SizedBox.shrink()
                        : sizeBoxHeight(10),
                    servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .serviceWebsite!
                            .isEmpty
                        ? SizedBox.shrink()
                        : InkWell(
                            onTap: () {
                              final url = servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .serviceWebsite!;
                              _launchURL(url);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Visit Website',
                                  style: AppTypography.text10Medium(context),
                                ),
                                Image.asset(
                                  'assets/images/export.png',
                                  height: 12,
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                ),
                              ],
                            ),
                          ),
                    sizeBoxHeight(10),
                    GestureDetector(
                      onTap: () async {
                        String email = Uri.encodeComponent(
                          servicecontro
                              .servicemodel
                              .value!
                              .serviceDetail!
                              .vendorEmail!
                              .toString(),
                        );
                        Uri mail = Uri.parse("mailto:$email");
                        if (await launchUrl(mail)) {
                          //email app opened
                          snackBar("email app opened");
                        } else {
                          //email app is not opened
                          snackBar("email app is not opened");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email on',
                            style: AppTypography.text10Medium(context),
                          ),
                          sizeBoxWidth(5),
                          Text(
                            servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .vendorEmail!
                                .toString(),
                            style: AppTypography.text10Medium(context).copyWith(
                              color: Appcolors.appPriSecColor.appPrimblue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    sizeBoxHeight(10),
                    hasAnySocialLink
                        ? Text(
                            'Follow us on',
                            style: AppTypography.text10Medium(context),
                          )
                        : SizedBox.shrink(),
                    hasAnySocialLink ? sizeBoxHeight(10) : SizedBox.shrink(),
                    hasAnySocialLink
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .whatsappLink !=
                                        ""
                                    ? socialLinkContainerDesign(
                                        context,
                                        onTap: () async {
                                          if (userID.isEmpty) {
                                            snackBar(
                                              "Contact on Whatsapp kidly login in",
                                            );
                                          } else {
                                            _launchWhatsapp(
                                              servicecontro
                                                  .servicemodel
                                                  .value!
                                                  .serviceDetail!
                                                  .whatsappLink
                                                  .toString(),
                                            );
                                          }
                                        },
                                        img: 'assets/images/whatsapp.png',
                                        imgHeigh: 18,
                                        title: 'Whatsapp',
                                      )
                                    : SizedBox.shrink(),
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .whatsappLink !=
                                        ""
                                    ? sizeBoxWidth(9)
                                    : SizedBox.shrink(),
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .facebookLink !=
                                        ""
                                    ? socialLinkContainerDesign(
                                        context,
                                        onTap: () {
                                          if (userID.isEmpty) {
                                            snackBar(
                                              "Contact on Facebook kidly login in",
                                            );
                                          } else {
                                            _launchSocial(
                                              servicecontro
                                                  .servicemodel
                                                  .value!
                                                  .serviceDetail!
                                                  .facebookLink!,
                                            );
                                          }
                                        },
                                        img: 'assets/images/Facebook.png',
                                        imgHeigh: 18,
                                        title: 'Facebook',
                                      )
                                    : SizedBox.shrink(),
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .facebookLink !=
                                        ""
                                    ? sizeBoxWidth(9)
                                    : SizedBox.shrink(),
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .instagramLink !=
                                        ""
                                    ? socialLinkContainerDesign(
                                        context,
                                        onTap: () {
                                          if (userID.isEmpty) {
                                            snackBar(
                                              "Contact on instagram kidly login in",
                                            );
                                          } else {
                                            launchUrl(
                                              Uri.parse(
                                                servicecontro
                                                    .servicemodel
                                                    .value!
                                                    .serviceDetail!
                                                    .instagramLink!,
                                              ),
                                              // Uri.parse('https://www.instagram.com/forwheel_app/'),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          }
                                        },
                                        img: 'assets/images/instagram.png',
                                        imgHeigh: 15,
                                        title: 'Instagram',
                                      )
                                    : SizedBox.shrink(),
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .instagramLink !=
                                        ""
                                    ? sizeBoxWidth(9)
                                    : SizedBox.shrink(),
                                servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .twitterLink !=
                                        ""
                                    ? socialLinkContainerDesign(
                                        context,
                                        onTap: () {
                                          if (userID.isEmpty) {
                                            snackBar(
                                              "Contact on Twitter kidly login in",
                                            );
                                          } else {
                                            launchUrl(
                                              Uri.parse(
                                                servicecontro
                                                    .servicemodel
                                                    .value!
                                                    .serviceDetail!
                                                    .twitterLink!,
                                              ),
                                              // Uri.parse("http://twitter.com/example"),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          }
                                        },
                                        img: 'assets/images/twitter.png',
                                        imgHeigh: 15,
                                        title: 'Twitter',
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          )
                        : SizedBox.fromSize(),
                    hasAnySocialLink ? sizeBoxHeight(5) : SizedBox.shrink(),
                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: 20),
            // *********************************** Business Vendor Detail ************************************
            sizeBoxHeight(20),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.appBgColor.white
                    : Appcolors.appBgColor.darkGray,
                boxShadow: [
                  BoxShadow(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appShadowColor.cECECEC
                        : Appcolors.appShadowColor.darkShadowColor,
                    blurRadius: 14.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 4.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendor Information',
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(20),
                    Row(
                      children: [
                        Container(
                          height: getProportionateScreenHeight(50),
                          width: getProportionateScreenWidth(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: servicecontro
                                  .servicemodel
                                  .value!
                                  .vendorDetails!
                                  .image!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return containerCapiltal(
                                  height: getProportionateScreenHeight(50),
                                  width: getProportionateScreenWidth(50),
                                  fontSize: 20,
                                  text: servicecontro
                                      .servicemodel
                                      .value!
                                      .vendorDetails!
                                      .firstName!,
                                );
                              },
                            ),
                          ),
                        ),
                        sizeBoxWidth(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    truncateText(
                                      servicecontro
                                          .servicemodel
                                          .value!
                                          .vendorDetails!
                                          .firstName!,
                                    ),
                                    maxLines: 1,
                                    style: AppTypography.text14Medium(context)
                                        .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: themeContro.isLightMode.value
                                              ? Color(0xff636363)
                                              : Appcolors
                                                    .appTextColor
                                                    .textWhite,
                                        ),
                                  ),
                                  sizeBoxWidth(5),
                                  Image.asset(
                                    AppAsstes.verifyGreen,
                                    height: 14,
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    servicecontro
                                            .servicemodel
                                            .value!
                                            .stores!
                                            .isNotEmpty
                                        ? TextSpan(
                                            text:
                                                "${servicecontro.servicemodel.value!.stores!.length.toString()} Services",
                                            style:
                                                AppTypography.text12Medium(
                                                  context,
                                                ).copyWith(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Appcolors
                                                      .appPriSecColor
                                                      .appPrimblue,
                                                ),
                                          )
                                        : WidgetSpan(child: SizedBox.shrink()),
                                    servicecontro
                                            .servicemodel
                                            .value!
                                            .stores!
                                            .isNotEmpty
                                        ? WidgetSpan(child: sizeBoxWidth(5))
                                        : WidgetSpan(child: SizedBox.shrink()),
                                    TextSpan(
                                      text:
                                          "Members since ${servicecontro.servicemodel.value!.serviceDetail!.publishedYear!}",
                                      style: AppTypography.text12Medium(context)
                                          .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: themeContro.isLightMode.value
                                                ? Color(0xff636363)
                                                : Appcolors
                                                      .appTextColor
                                                      .textWhite,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: 20),
            servicecontro
                    .servicemodel
                    .value!
                    .vendorDetails!
                    .employeeStrength!
                    .isNotEmpty
                ? sizeBoxHeight(20)
                : SizedBox.shrink(),
            servicecontro
                    .servicemodel
                    .value!
                    .vendorDetails!
                    .employeeStrength!
                    .isNotEmpty
                ? Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.white
                          : Appcolors.appBgColor.darkGray,
                      boxShadow: [
                        BoxShadow(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appShadowColor.cECECEC
                              : Appcolors.appShadowColor.darkShadowColor,
                          blurRadius: 14.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 4.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No. of employees',
                            style: AppTypography.text14Medium(
                              context,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          sizeBoxHeight(20),
                          Row(
                            children: [
                              Image.asset(
                                AppAsstes.profile2user,
                                height: 20,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                              ),
                              sizeBoxWidth(10),
                              Text(
                                servicecontro
                                    .servicemodel
                                    .value!
                                    .vendorDetails!
                                    .employeeStrength!,
                                style: AppTypography.text14Medium(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 20)
                : SizedBox.shrink(),
            sizeBoxHeight(10),
            // *********************************** Business services *****************************************
            servicecontro.servicemodel.value!.stores!.isNotEmpty
                ? sizeBoxHeight(10)
                : SizedBox.shrink(),
            servicecontro.servicemodel.value!.stores!.isNotEmpty
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Services',
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ).paddingSymmetric(horizontal: 20)
                : SizedBox.shrink(),
            servicecontro.servicemodel.value!.stores!.isNotEmpty
                ? sizeBoxHeight(10)
                : SizedBox.shrink(),
            servicecontro.servicemodel.value!.stores!.isNotEmpty
                ? Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.white
                          : Appcolors.appBgColor.darkGray,
                      boxShadow: [
                        BoxShadow(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appShadowColor.cECECEC
                              : Appcolors.appShadowColor.darkShadowColor,
                          blurRadius: 14.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 4.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          servicecontro.servicemodel.value!.stores!.isNotEmpty
                              ? ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: themeContro.isLightMode.value
                                          ? Color(0xffCCCCCC)
                                          : Appcolors.darkBorder,
                                      thickness: 1,
                                    );
                                  },
                                  itemCount: servicecontro
                                      .servicemodel
                                      .value!
                                      .stores!
                                      .length
                                      .clamp(0, 2),
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return overviewservicedata(
                                      servicecontro
                                          .servicemodel
                                          .value!
                                          .stores![index],
                                      index,
                                    );
                                  },
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: SizedBox(
                                      height: 80,
                                      child: label(
                                        "No Services Found",
                                        fontSize: 16,
                                        textColor: Appcolors.brown,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                          sizeBoxHeight(10),
                          servicecontro.servicemodel.value!.stores!.isNotEmpty
                              ? servicecontro
                                            .servicemodel
                                            .value!
                                            .stores!
                                            .length >
                                        2
                                    ? Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Get.to(AllService(),
                                            //     transition: Transition.downToUp);

                                            //  services();
                                            _tabController.index = 1;
                                          },
                                          child: Container(
                                            height: 22,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Appcolors
                                                    .appPriSecColor
                                                    .appPrimblue,
                                              ),
                                            ),
                                            child: Center(
                                              child: label(
                                                'See All Services',
                                                fontSize: 7,
                                                fontWeight: FontWeight.w500,
                                                textColor: Appcolors
                                                    .appPriSecColor
                                                    .appPrimblue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink()
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 20)
                : SizedBox.shrink(),
            sizeBoxHeight(12),
            // *********************************** Business photos *****************************************
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Photos',
                style: AppTypography.text14Medium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(10),
            Container(
              height: 70,
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.appBgColor.white
                    : Appcolors.appBgColor.darkGray,
                boxShadow: [
                  BoxShadow(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appShadowColor.cECECEC
                        : Appcolors.appShadowColor.darkShadowColor,
                    blurRadius: 14.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 4.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .serviceImages!
                                    .length >
                                5
                            ? 5
                            : servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .serviceImages!
                                  .length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final images = servicecontro
                              .servicemodel
                              .value!
                              .serviceDetail!
                              .serviceImages!;
                          final remainingImages = images.length - 5;

                          if (index < 4 || images.length <= 5) {
                            // Show first 4 images normally OR all images if <= 5
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Appcolors.black.withOpacity(
                                    0.5,
                                  ),
                                  builder: (BuildContext context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY: 5.0,
                                      ),
                                      child: AlertDialog(
                                        backgroundColor:
                                            Appcolors.appBgColor.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        insetPadding: EdgeInsets.zero,
                                        contentPadding: EdgeInsets.zero,
                                        content: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child: posterDialog2(context, index),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      images[index].toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ).paddingSymmetric(horizontal: 5),
                            );
                          } else if (index == 4 && images.length > 5) {
                            // Show 5th image with overlay if more images exist
                            return GestureDetector(
                              onTap: () {
                                _tabController.index = 2;
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          images[index].toString(),
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Appcolors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "+$remainingImages",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolors.appTextColor.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 5),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(12),
            // *********************************** Business review *****************************************
            servicecontro.servicemodel.value!.serviceDetail!.reviews!.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Review',
                        style: AppTypography.text14Medium(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      servicecontro
                              .servicemodel
                              .value!
                              .serviceDetail!
                              .reviews!
                              .isNotEmpty
                          ? servicecontro
                                        .servicemodel
                                        .value!
                                        .serviceDetail!
                                        .reviews!
                                        .length >
                                    2
                                ? GestureDetector(
                                    onTap: () {
                                      // Get.to(StoreReview())
                                      _tabController.index = 3;
                                    },
                                    child: label(
                                      'See all',
                                      fontSize: 11,
                                      textColor:
                                          Appcolors.appPriSecColor.appPrimblue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : SizedBox.shrink()
                          : SizedBox.shrink(),
                    ],
                  ).paddingOnly(left: 22, right: 22, bottom: 10)
                : SizedBox.shrink(),
            servicecontro.servicemodel.value!.serviceDetail!.reviews!.isNotEmpty
                ? Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      boxShadow: [
                        BoxShadow(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textLighGray
                              : Appcolors.darkShadowColor,
                          blurRadius: 14.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            2.0,
                            4.0,
                          ), // shadow direction: bottom right
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizeBoxHeight(15),
                        servicecontro.servicemodel.value!.vendor.toString() ==
                                userID
                            ? SizedBox.shrink()
                            : Row(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: ListView.builder(
                                      itemCount: 5,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Call the API to like/unlike the service
                                              if (userID.isEmpty) {
                                                snackBar(
                                                  'Please login to review this service',
                                                );
                                                loginPopup(
                                                  bottomsheetHeight:
                                                      Get.height * 0.95,
                                                );
                                              } else {
                                                reviewDialog();
                                              }
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Appcolors
                                                    .appTextColor
                                                    .textLighGray,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/star1.png',
                                                  height: 25,
                                                  width: 25,
                                                  color: Appcolors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 10),
                        servicecontro.servicemodel.value!.vendor.toString() ==
                                userID
                            ? SizedBox.shrink()
                            : sizeBoxHeight(15),
                        Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Appcolors.appPriSecColor.appPrimblue,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  servicecontro
                                      .servicemodel
                                      .value!
                                      .serviceDetail!
                                      .totalAvgReview
                                      .toString(),
                                  style: AppTypography.text14Medium(context)
                                      .copyWith(
                                        color: Appcolors.appTextColor.textWhite,
                                      ),
                                ),
                              ),
                            ),
                            sizeBoxWidth(10),
                            Text(
                              '${servicecontro.servicemodel.value!.serviceDetail!.totalReviewCount} '
                              '${servicecontro.servicemodel.value!.serviceDetail!.totalReviewCount == 1 ? "rating" : "ratings"}',
                              style: AppTypography.text11Regular(context),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 15),
                        sizeBoxHeight(18),
                        servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .reviews!
                                .isNotEmpty
                            ? ListView.builder(
                                itemCount: servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .reviews!
                                    .length
                                    .clamp(0, 2),
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return review(
                                    context,
                                    time: servicecontro
                                        .servicemodel
                                        .value!
                                        .serviceDetail!
                                        .reviews![index]
                                        .createdAt
                                        .toString(),
                                    fname:
                                        '${servicecontro.servicemodel.value!.serviceDetail!.reviews![index].firstName.toString() + " " + servicecontro.servicemodel.value!.serviceDetail!.reviews![index].lastName.toString()}',
                                    descname: servicecontro
                                        .servicemodel
                                        .value!
                                        .serviceDetail!
                                        .reviews![index]
                                        .reviewMessage
                                        .toString(),
                                    // content: 'super',
                                    imagepath: servicecontro
                                        .servicemodel
                                        .value!
                                        .serviceDetail!
                                        .reviews![index]
                                        .image
                                        .toString(),
                                    ratingCount:
                                        servicecontro
                                                .servicemodel
                                                .value!
                                                .serviceDetail!
                                                .reviews![index]
                                                .reviewStar
                                                .toString() !=
                                            ''
                                        ? double.parse(
                                            servicecontro
                                                .servicemodel
                                                .value!
                                                .serviceDetail!
                                                .reviews![index]
                                                .reviewStar
                                                .toString(),
                                          )
                                        : 0.0,
                                  ).paddingSymmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  );
                                },
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 20)
                : SizedBox.shrink(),
            sizeBoxHeight(100),
          ],
        ),
      ),
    );
  }

  // Assuming you're using GetX

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget customerreview() {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkMainBlack,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  servicecontro.servicemodel.value!.vendor.toString() == userID
                      ? languageController.textTranslate('Reviews')
                      : languageController.textTranslate('Start Your Review'),
                  style: AppTypography.text14Medium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .reviews!
                            .length >
                        3
                    ? GestureDetector(
                        onTap: () {
                          Get.to(StoreReview());
                        },
                        child: label(
                          'See all',
                          fontSize: 11,
                          textColor: Appcolors.appPriSecColor.appPrimblue,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ).paddingSymmetric(horizontal: 20, vertical: 10),
            sizeBoxHeight(5),
            servicecontro.servicemodel.value!.vendor.toString() == userID
                ? SizedBox.shrink()
                : Row(
                    children: [
                      SizedBox(
                        height: 35,
                        child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (userID.isEmpty) {
                                    snackBar(
                                      'Please login to review this service',
                                    );
                                    loginPopup(
                                      bottomsheetHeight: Get.height * 0.95,
                                    );
                                  } else {
                                    // _confirmReview();
                                    reviewDialog();
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.appTextColor.textLighGray
                                        : Color(0xff323232),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/star1.png',
                                      color: Appcolors.white,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 17),
            servicecontro.servicemodel.value!.vendor.toString() == userID
                ? SizedBox.shrink()
                : sizeBoxHeight(15),
            Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      servicecontro
                          .servicemodel
                          .value!
                          .serviceDetail!
                          .totalAvgReview
                          .toString(),
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(color: Appcolors.appTextColor.textWhite),
                    ),
                  ),
                ),
                sizeBoxWidth(10),
                Text(
                  '${servicecontro.servicemodel.value!.serviceDetail!.totalReviewCount} '
                  '${servicecontro.servicemodel.value!.serviceDetail!.totalReviewCount == 1 ? "rating" : "ratings"}',
                  style: AppTypography.text11Regular(context),
                ),
              ],
            ).paddingSymmetric(horizontal: 22),
            sizeBoxHeight(18),
            servicecontro.servicemodel.value!.serviceDetail!.reviews!.isNotEmpty
                ? ListView.builder(
                    itemCount: servicecontro
                        .servicemodel
                        .value!
                        .serviceDetail!
                        .reviews!
                        .length
                        .clamp(0, 3),
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return review(
                        context,
                        time: servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .reviews![index]
                            .createdAt
                            .toString(),
                        fname:
                            '${servicecontro.servicemodel.value!.serviceDetail!.reviews![index].firstName.toString() + " " + servicecontro.servicemodel.value!.serviceDetail!.reviews![index].lastName.toString()}',
                        descname: servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .reviews![index]
                            .reviewMessage
                            .toString(),
                        // content: 'super',
                        imagepath: servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .reviews![index]
                            .image
                            .toString(),
                        ratingCount:
                            servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .reviews![index]
                                    .reviewStar
                                    .toString() !=
                                ''
                            ? double.parse(
                                servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .reviews![index]
                                    .reviewStar
                                    .toString(),
                              )
                            : 0.0,
                      ).paddingSymmetric(horizontal: 13, vertical: 15);
                    },
                  ).paddingSymmetric(horizontal: 10)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          sizeBoxHeight(Get.height * 0.1),
                          SizedBox(
                            height: 100,
                            child: Image.asset(
                              AppAsstes.emptyImage,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          sizeBoxHeight(10),
                          label(
                            languageController.textTranslate(
                              "No Reviews found",
                            ),
                            fontSize: 15,
                            textColor: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
            sizeBoxHeight(100),
          ],
        ),
      ),
    );
  }

  Widget photos() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkMainBlack,
      ),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Photos',
                style: AppTypography.text14Medium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ).paddingSymmetric(horizontal: 20, vertical: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: SizedBox(
                // Set an appropriate height for the GridView
                child:
                    servicecontro
                        .servicemodel
                        .value!
                        .serviceDetail!
                        .serviceImages!
                        .isNotEmpty
                    ? GridView.builder(
                        padding: EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 items per row
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .serviceImages!
                            .length,
                        shrinkWrap: true, // Number of items in the grid
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Appcolors.black.withOpacity(0.5),
                                builder: (BuildContext context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5.0,
                                      sigmaY: 5.0,
                                    ),
                                    child: AlertDialog(
                                      backgroundColor:
                                          Appcolors.appBgColor.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      insetPadding: EdgeInsets.zero,
                                      contentPadding: EdgeInsets.zero,
                                      content: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: posterDialog2(context, index),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Appcolors.appShadowColor.cECECEC,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: servicecontro
                                      .servicemodel
                                      .value!
                                      .serviceDetail!
                                      .serviceImages![index]
                                      .toString(),
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) {
                                    return CupertinoActivityIndicator();
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                sizeBoxHeight(Get.height * 0.2),
                                SizedBox(
                                  height: 100,
                                  child: Image.asset(
                                    AppAsstes.emptyImage,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                sizeBoxHeight(10),
                                label(
                                  languageController.textTranslate(
                                    "No Data Found",
                                  ),
                                  fontSize: 15,
                                  textColor: themeContro.isLightMode.value
                                      ? Appcolors.black
                                      : Appcolors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            servicecontro.servicemodel.value!.serviceDetail!.video!.isNotEmpty
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Video',
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ).paddingSymmetric(horizontal: 20, vertical: 10)
                : SizedBox.shrink(),
            servicecontro.servicemodel.value!.serviceDetail!.video!.isNotEmpty
                ? sizeBoxHeight(5)
                : SizedBox.shrink(),
            servicecontro.servicemodel.value!.serviceDetail!.video!.isNotEmpty
                ? InkWell(
                    onTap: () {
                      if (servicecontro
                          .servicemodel
                          .value!
                          .serviceDetail!
                          .video!
                          .isNotEmpty) {
                        _video(
                          url: servicecontro
                              .servicemodel
                              .value!
                              .serviceDetail!
                              .video
                              .toString(),
                        );
                      } else {
                        snackBar("Video not available");
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(120),
                          width: getProportionateScreenWidth(110),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Appcolors.appShadowColor.cECECEC,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .videoThumbnail!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Center(
                                  child: Icon(
                                    Icons.video_camera_back_outlined,
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Appcolors.white.withOpacity(0.1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Image.asset(
                                  AppAsstes.play2,
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                  height: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget services() {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkMainBlack,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            searchBar(),
            sizeBoxHeight(20),
            Text(
              servicecontro.servicemodel.value!.serviceDetail!.serviceName
                  .toString(),
              style: AppTypography.text14Medium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(20),
            servicecontro.servicemodel.value!.stores!.isNotEmpty
                ? (_searchResult.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Appcolors.appOppaColor.appPrimOppacity,
                              thickness: 1,
                            ).paddingSymmetric(horizontal: 20);
                          },
                          itemCount: _searchResult.length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return servicedata(
                              _searchResult[index],
                              index,
                              key: ValueKey(
                                'search_item_${_searchResult[index].id}_$index',
                              ),
                            );
                          },
                        )
                      : searchController.text.trim().isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                sizeBoxHeight(Get.height * 0.2),
                                SizedBox(
                                  height: 100,
                                  child: Image.asset(
                                    AppAsstes.emptyImage,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                sizeBoxHeight(10),
                                label(
                                  languageController.textTranslate(
                                    "No Data Found",
                                  ),
                                  fontSize: 15,
                                  textColor: themeContro.isLightMode.value
                                      ? Appcolors.black
                                      : Appcolors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Appcolors.appOppaColor.appPrimOppacity,
                              thickness: 1,
                            ).paddingSymmetric(horizontal: 20);
                          },
                          itemCount:
                              servicecontro.servicemodel.value!.stores!.length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return servicedata(
                              servicecontro.servicemodel.value!.stores![index],
                              index,
                              key: ValueKey(
                                'search_item_${servicecontro.servicemodel.value!.stores![index].id}_$index',
                              ),
                            );
                          },
                        ))
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          sizeBoxHeight(Get.height * 0.2),
                          SizedBox(
                            height: 100,
                            child: Image.asset(
                              AppAsstes.emptyImage,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          sizeBoxHeight(10),
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
                    ),
                  ),
            sizeBoxHeight(100),
          ],
        ),
      ),
    );
  }

  Widget overviewservicedata(Stores store, index) {
    return GestureDetector(
      onTap: () {
        Get.to(SubDetails(index: index), transition: Transition.rightToLeft);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.grey200
                    : Appcolors.darkBorder,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: store.storeImages![0].toString(),
                placeholder: (context, url) {
                  return CupertinoActivityIndicator();
                },
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Icon(Icons.error);
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(200),
                      child: label(
                        store.storeName.toString(),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.appPriSecColor.appPrimblue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          SubDetails(index: index),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Appcolors.appPriSecColor.appPrimblue,
                      ),
                    ),
                  ],
                ),
                sizeBoxHeight(5),
                SizedBox(
                  width: 195,
                  child: Text(
                    convertHtmlToText(store.storeDescription.toString()),

                    style: poppinsFont(
                      11,
                      themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      FontWeight.w500,
                    ),
                  ).paddingOnly(right: 10),
                ),
                sizeBoxHeight(10),
              ],
            ).paddingSymmetric(horizontal: 9),
          ),
        ],
      ),
    );
  }

  Widget servicedata(Stores store, index, {Key? key}) {
    return GestureDetector(
      onTap: () {
        Get.to(SubDetails(index: index), transition: Transition.rightToLeft);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.appShadowColor.cECECEC
                    : Appcolors.appShadowColor.darkBorder,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: store.storeImages![0].toString(),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Icon(
                    Icons.error,
                    size: 20,
                    color: themeContro.isLightMode.value
                        ? Appcolors.appBgColor.darkMainBlack
                        : Appcolors.appBgColor.darkGray,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.52,
                      child: Text(
                        store.storeName.toString(),
                        style: AppTypography.text12Medium(context).copyWith(
                          color: Appcolors.appPriSecColor.appPrimblue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          SubDetails(index: index),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Appcolors.appPriSecColor.appPrimblue,
                      ),
                    ),
                  ],
                ),
                sizeBoxHeight(5),
                SizedBox(
                  width: Get.width * 0.60,
                  child: Text(
                    convertHtmlToText(store.storeDescription.toString()),
                    style: AppTypography.text9Regular(
                      context,
                    ).copyWith(fontSize: 10),
                  ).paddingOnly(right: 10),
                ),
                sizeBoxHeight(10),
              ],
            ).paddingSymmetric(horizontal: 9),
          ),
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }

  final searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 0,
      child: TextField(
        controller: searchController,
        cursorColor: Appcolors.grey400,
        onChanged: onSearchTextChanged,
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.grey400 : Appcolors.white,
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
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: "Search Services",
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
      ).paddingSymmetric(horizontal: 18),
    );
  }

  Widget bottam() {
    return Row(
      children: [
        Expanded(
          child: btnCallChatWhp(
            onTap: () async {
              if (userID.isEmpty) {
                snackBar("Login must need for see mobile number");
              } else {
                ("tapped_call");
                if (servicecontro
                    .servicemodel
                    .value!
                    .serviceDetail!
                    .servicePhone!
                    .isNotEmpty) {
                  (
                    servicecontro
                        .servicemodel
                        .value!
                        .serviceDetail!
                        .servicePhone!,
                  );
                  servicecontro.leadApi(serviceID: widget.serviceid!);
                  String phoneNum = Uri.encodeComponent(
                    servicecontro
                        .servicemodel
                        .value!
                        .serviceDetail!
                        .servicePhone!
                        .toString(),
                  );
                  Uri tel = Uri.parse("tel:$phoneNum");
                  if (await launchUrl(tel)) {
                    //phone dail app is opened
                  } else {
                    //phone dail app is not opened
                    snackBar('Phone dail not opened');
                  }
                }
              }
            },
            title: 'Call',
            img: 'assets/images/call.png',
            isValue:
                servicecontro
                    .servicemodel
                    .value!
                    .serviceDetail!
                    .servicePhone!
                    .isNotEmpty
                ? true
                : false,
          ),
        ),
        sizeBoxWidth(10),
        Expanded(
          child: btnCallChatWhp(
            onTap: () {
              if (userID.isEmpty) {
                snackBar("Login must need for chat with vendor");
              } else {
                setState(() {
                  servicecontro.leadApi(serviceID: widget.serviceid!);
                });
                Get.to(
                  () => ChatScreen2(
                    isLead: "1",
                    toUserID: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .id
                        .toString(),
                    isRought: true,
                    fname: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .firstName,
                    lname: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .lastName,
                    profile:
                        servicecontro.servicemodel.value!.vendorDetails!.image,
                    lastSeen: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .lastSeen,
                    block: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .isBlock,
                  ),
                  transition: Transition.rightToLeft,
                );
              }
            },
            title: 'Chat',
            img: 'assets/images/message-2.png',
            isValue: true,
          ),
        ),
        sizeBoxWidth(10),
        Expanded(
          child: btnCallChatWhp(
            onTap: () async {
              if (userID.isEmpty) {
                snackBar("Login must need for see whatsapp number");
              } else {
                setState(() {
                  servicecontro.leadApi(serviceID: widget.serviceid!);
                });
                _launchWhatsapp(
                  servicecontro.servicemodel.value!.serviceDetail!.whatsappLink
                      .toString(),
                );
              }
            },
            title: 'Whatsapp',
            img: 'assets/images/whatsapp.png',
            isValue:
                servicecontro
                    .servicemodel
                    .value!
                    .serviceDetail!
                    .whatsappLink!
                    .isNotEmpty
                ? true
                : false,
          ),
        ),
      ],
    );
  }

  Widget btnCallChatWhp({
    required Function() onTap,
    required String title,
    required String img,
    required bool isValue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isValue
                ? Appcolors.appPriSecColor.appPrimblue
                : Appcolors.appTextColor.textLighGray,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 12,
              color: title == 'Whatsapp'
                  ? null
                  : isValue
                  ? Appcolors.appPriSecColor.appPrimblue
                  : Appcolors.appTextColor.textLighGray,
            ),
            sizeBoxWidth(5),
            Text(
              title,
              style: AppTypography.text10Regular(context).copyWith(
                color: isValue
                    ? Appcolors.appPriSecColor.appPrimblue
                    : Appcolors.appTextColor.textLighGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isBusinessOpen() {
    String today = DateFormat('E').format(DateTime.now());
    if (servicecontro.servicemodel.value!.serviceDetail!.closedDays!.contains(
      today,
    )) {
      return false;
    }
    return true;
  }

  List days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  void _buisnessHour() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            alignment: Alignment.bottomCenter,
            insetPadding: EdgeInsets.only(top: 5),
            contentPadding: EdgeInsets.zero,
            backgroundColor: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkMainBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: StatefulBuilder(
              builder: (context, kk) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(350),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: themeContro.isLightMode.value
                              ? Appcolors.white
                              : Appcolors.darkMainBlack,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    label(
                                      'Business Hours',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      textColor: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: themeContro.isLightMode.value
                                            ? Appcolors.black
                                            : Appcolors.white,
                                      ),
                                    ),
                                  ],
                                )
                                .paddingSymmetric(horizontal: 20)
                                .paddingOnly(top: 10),
                            sizeBoxHeight(6),
                            Divider(
                              color: themeContro.isLightMode.value
                                  ? Color(0xffCCCCCC)
                                  : Appcolors.darkgray2,
                              thickness: 1,
                            ),
                            sizeBoxHeight(5),
                            ListView.builder(
                              itemCount: 7,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/addtime.png',
                                            height: 12,
                                            width: 12,
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue,
                                          ),
                                          sizeBoxWidth(6),
                                          label(
                                            days[index],
                                            fontSize: 13,
                                            textColor:
                                                themeContro.isLightMode.value
                                                ? Appcolors.black
                                                : Appcolors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      servicecontro
                                              .servicemodel
                                              .value!
                                              .serviceDetail!
                                              .closedDays!
                                              .contains(
                                                days[index]
                                                    .toString()
                                                    .substring(0, 3),
                                              )
                                          ? label(
                                              'Closed',
                                              fontSize: 11,
                                              textColor: Appcolors
                                                  .appTextColor
                                                  .textRedColor,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : label(
                                              '${servicecontro.servicemodel.value!.serviceDetail!.openTime.toString()} - ${servicecontro.servicemodel.value!.serviceDetail!.closeTime.toString()}',
                                              fontSize: 11,
                                              textColor: Appcolors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future reviewDialog() {
    return bottomSheetGobal(
      context,
      bottomsheetHeight: getProportionateScreenHeight(500),
      title: 'Review & Rating',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizeBoxHeight(30),
          label(
            'Feel Free to share your review and ratings',
            fontSize: 14,
            textColor: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            fontWeight: FontWeight.w500,
          ).paddingSymmetric(horizontal: 25),
          sizeBoxHeight(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                unratedColor: Appcolors.grey400,
                itemCount: 5,
                itemSize: 25,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Image.asset(
                  'assets/images/star1.png',
                  color: Color(0xffFFA41C),
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rateValue = rating;
                  });
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 25),
          sizeBoxHeight(22),
          TextFormField(
            cursorColor: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            autofocus: false,
            controller: msgController,
            style: TextStyle(
              fontSize: 14,
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              fontWeight: FontWeight.w400,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: false,
            keyboardType: TextInputType.text,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: Appcolors.appPriSecColor.appPrimblue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Appcolors.grey),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Appcolors.grey),
              ),
              hintText: "Write Your Review....",
              hintStyle: TextStyle(
                fontSize: 12,
                color: Appcolors.grey,
                fontWeight: FontWeight.w400,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Appcolors.grey),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Appcolors.grey),
              ),
              errorStyle: TextStyle(
                color: Appcolors.appTextColor.textRedColor,
                fontSize: 10,
              ),
            ),
          ).paddingSymmetric(horizontal: 25),
          sizeBoxHeight(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(140),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appPriSecColor.appPrimblue
                          : Appcolors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: label(
                      'Cancel',
                      fontSize: 14,
                      textColor: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              sizeBoxWidth(10),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    final success = await addreviewcontro.addreviewApi(
                      widget.serviceid!,
                      rateValue.toString().replaceAll(".0", ""),
                      msgController.text,
                    );

                    if (success) {
                      msgController.clear();
                      addreviewcontro.addreviewmodel.refresh();
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: getProportionateScreenWidth(140),
                    decoration: BoxDecoration(
                      color: Appcolors.appPriSecColor.appPrimblue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: addreviewcontro.isaddreview.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: commonLoadingWhite(),
                            )
                          : label(
                              'Send',
                              fontSize: 14,
                              textColor: Appcolors.white,
                              fontWeight: FontWeight.w400,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget imagelistt() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 350,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: _poster2(context),
        ),
        servicecontro.servicemodel.value!.vendor.toString() == userID
            ? SizedBox.shrink()
            : Positioned(
                top: 25,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    if (userID.isEmpty) {
                      snackBar('Please login to like this service');
                      loginPopup(bottomsheetHeight: Get.height * 0.95);
                    } else {
                      likecontro.likeApi(
                        servicecontro.servicemodel.value!.serviceDetail!.id
                            .toString(),
                      );
                      setState(() {
                        servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .isLike =
                            servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .isLike ==
                                0
                            ? 1
                            : 0;

                        for (
                          int i = 0;
                          i < homecontro.allcatelist.length;
                          i++
                        ) {
                          if (homecontro.allcatelist[i].id ==
                              servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .id) {
                            homecontro.allcatelist[i].isLike = servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .isLike;
                            homecontro.allcatelist.refresh();
                          }
                        }

                        for (int i = 0; i < homecontro.nearbylist.length; i++) {
                          if (homecontro.nearbylist[i].id ==
                              servicecontro
                                  .servicemodel
                                  .value!
                                  .serviceDetail!
                                  .id) {
                            homecontro.nearbylist[i].isLike = servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .isLike;
                            homecontro.nearbylist.refresh();
                          }
                        }
                      });
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolors.white.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              servicecontro
                                      .servicemodel
                                      .value!
                                      .serviceDetail!
                                      .isLike ==
                                  0
                              ? Image.asset(AppAsstes.heart)
                              : Image.asset(AppAsstes.fill_heart),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Positioned(
          top: 25,
          left: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.asset(
                  'assets/images/arrow-left1.png',
                  height: 24,
                ).paddingAll(5),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textLighGray
                              : Appcolors.darkShadowColor,
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          servicecontro
                                              .servicemodel
                                              .value!
                                              .vendorDetails!
                                              .image
                                              .toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  label(
                                    servicecontro
                                        .servicemodel
                                        .value!
                                        .vendorDetails!
                                        .firstName
                                        .toString(),
                                    fontSize: 11,
                                    textColor: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              Container(
                                height: getProportionateScreenHeight(22),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Appcolors.appPriSecColor.appPrimblue
                                      .withValues(alpha: 0.10),
                                ),
                                child: Center(
                                  child: Text(
                                    servicecontro
                                        .servicemodel
                                        .value!
                                        .serviceDetail!
                                        .categoryName
                                        .toString(),
                                    style: poppinsFont(
                                      8,
                                      Appcolors.appPriSecColor.appPrimblue,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ).paddingSymmetric(horizontal: 5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          label(
                            servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .serviceName
                                .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            textColor: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBar.builder(
                                    initialRating:
                                        servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .totalAvgReview!
                                            .isNotEmpty
                                        ? double.parse(
                                            servicecontro
                                                .servicemodel
                                                .value!
                                                .serviceDetail!
                                                .totalAvgReview!,
                                          )
                                        : 0,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 12.5,
                                    ignoreGestures: true,
                                    unratedColor: Appcolors.grey400,
                                    itemBuilder: (context, _) => Image.asset(
                                      'assets/images/Star.png',
                                      height: 16,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(width: 5),
                                  label(
                                    '(${servicecontro.servicemodel.value!.serviceDetail!.totalReviewCount!.toString()} Review)',
                                    fontSize: 10,
                                    textColor: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ).paddingOnly(right: 14),
                              label(
                                '${servicecontro.servicemodel.value!.serviceDetail!.totalYearsCount!.toString()} Years in Business',
                                fontSize: 11,
                                textColor: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          sizeBoxHeight(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              servicecontro
                                      .servicemodel
                                      .value!
                                      .serviceDetail!
                                      .distance!
                                      .isEmpty
                                  ? SizedBox.shrink()
                                  : Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/routing.png',
                                          height: 15,
                                        ),
                                        sizeBoxWidth(5),
                                        label(
                                          servicecontro
                                              .servicemodel
                                              .value!
                                              .serviceDetail!
                                              .distance!
                                              .toString(),
                                          fontSize: 11,
                                          textColor:
                                              themeContro.isLightMode.value
                                              ? Appcolors.black
                                              : Appcolors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                              isBusinessOpen()
                                  ? Row(
                                      children: [
                                        label(
                                          'Open',
                                          fontSize: 11,
                                          textColor: Color(0xff4CAF50),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        label(
                                          ' Until ${servicecontro.servicemodel.value!.serviceDetail!.closeTime!.toString()}',
                                          fontSize: 11,
                                          textColor:
                                              themeContro.isLightMode.value
                                              ? Appcolors.black
                                              : Appcolors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    )
                                  : label(
                                      'Closed',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          Appcolors.appTextColor.textRedColor,
                                    ),
                            ],
                          ),
                          sizeBoxHeight(10),
                          Container(
                            height: getProportionateScreenHeight(45),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: themeContro.isLightMode.value
                                  ? Appcolors.white
                                  : Appcolors.appPriSecColor.appPrimblue
                                        .withValues(alpha: 0.17),
                              border: Border.all(
                                color: Appcolors.appPriSecColor.appPrimblue,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${languageController.textTranslate("From")} ${servicecontro.servicemodel.value!.serviceDetail!.priceRange}",
                                style: poppinsFont(
                                  14,
                                  themeContro.isLightMode.value
                                      ? Appcolors.appPriSecColor.appPrimblue
                                      : Appcolors.appTextColor.textWhite,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -8,
                right: 20,
                child:
                    servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .isFeatured ==
                        0
                    ? SizedBox.shrink()
                    : Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: Appcolors.appTextColor.textRedColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/energy.png',
                                height: 9,
                                width: 9,
                              ),
                              sizeBoxWidth(3),
                              label(
                                'Sponsored',
                                style: TextStyle(
                                  color: Appcolors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 4, right: 4),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> whatsapp() async {
    var contact = servicecontro.servicemodel.value!.serviceDetail!.servicePhone!
        .toString();

    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }

  void _video({required String url}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            alignment: Alignment.center,
            insetPadding: const EdgeInsets.only(
              bottom: 20,
              left: 10,
              right: 10,
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Appcolors.appBgColor.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: StatefulBuilder(
              builder: (context, kk) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: getProportionateScreenHeight(35),
                        width: getProportionateScreenWidth(35),
                        decoration: BoxDecoration(
                          color: Appcolors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(child: Icon(Icons.close, size: 15)),
                        ),
                      ),
                    ),
                    sizeBoxHeight(10),
                    Container(
                      height: getProportionateScreenHeight(500),
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: VideoViewFix(url: url, play: true, mute: false),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  double rateValue = 0;

  void onSearchTextChanged(String text) {
    _searchResult.clear();

    if (text.isEmpty) {
      setState(() {
        _searchResult.addAll(servicecontro.servicemodel.value!.stores!);
      });
      return;
    }

    for (var userDetail in servicecontro.servicemodel.value!.stores!) {
      if (userDetail.storeName != null)
        if (userDetail.storeName!.toLowerCase().contains(text.toLowerCase())) {
          _searchResult.add(userDetail);
        }
    }

    setState(() {});
  }
}

List _searchResult = [];
