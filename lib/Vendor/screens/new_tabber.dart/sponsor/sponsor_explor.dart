// ignore_for_file: must_be_immutable, deprecated_member_use, avoid_print, unused_field
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/controllers/vendor_controllers/location_controller.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/sponsor/create_audiance.dart';

class SponsorExplor extends StatefulWidget {
  String? latt;
  String? lonn;
  String? vendorid;
  String? serviceid;
  String? addrss;
  SponsorExplor({
    super.key,
    this.latt,
    this.lonn,
    this.vendorid,
    this.serviceid,
    this.addrss,
  });

  @override
  State<SponsorExplor> createState() => _SponsorExplorState();
}

class _SponsorExplorState extends State<SponsorExplor> {
  late GoogleMapController mapController;
  LocationController locacontro = Get.find();

  final double _minRadius = 1000;
  final double _maxRadius = 10000;

  List<Marker> markerList = <Marker>[];

  Future<void> addMarker() async {
    if (widget.latt == null || widget.lonn == null) {
      return;
    }

    // Convert string to double safely
    double? latitude = double.tryParse(widget.latt!);
    double? longitude = double.tryParse(widget.lonn!);

    if (latitude == null || longitude == null) {
      return;
    }

    // Add marker only for the store location
    markerList.add(
      Marker(
        markerId: const MarkerId('StoreMarker'),
        position: LatLng(latitude, longitude),
        icon: await getCustomIcon(),
      ),
    );
  }

  Future<BitmapDescriptor> getCustomIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(2, 2)), // Icon size
      "assets/images/locationpick.png",
    );
  }

  Set<Circle> circlesss = {};

  Future<void> _setMapStyleLight() async {
    final style = await rootBundle.loadString('assets/map_styles/map.json');
    mapController.setMapStyle(style);
  }

  Future<void> _setMapStyleDark() async {
    String style = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/dark_map.json');
    mapController.setMapStyle(style);
  }

  @override
  void initState() {
    addMarker();
    double? lat = double.tryParse(widget.latt ?? '');
    double? lon = double.tryParse(widget.lonn ?? '');

    if (lat != null && lon != null) {
      circlesss.add(
        Circle(
          circleId: const CircleId('1'),
          center: LatLng(lat, lon),
          radius: locacontro.currentDistance.value.toDouble(),
          visible: true,
          strokeWidth: 1,
          strokeColor: Appcolors.appPriSecColor.appPrimblue.withOpacity(0.5),
          fillColor: Appcolors.appPriSecColor.appPrimblue.withOpacity(0.2),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Explore"),
            style: AppTypography.h1(context).copyWith(color: Appcolors.white),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [location()],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(
    String path,
    int width,
    int height,
  ) async {
    final byteData = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final frame = await codec.getNextFrame();
    return (await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  Widget location() {
    return FutureBuilder<Uint8List>(
      future: getBytesFromAsset('assets/images/locationpick.png', 10, 10),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Obx(() {
            return SizedBox(
              width: double.infinity, // Set width to full screen
              height: Get.height * 0.89, // Set a fixed height
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: Get.height * 0.89,
                      child: Obx(() {
                        return GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            if (themeContro.isLightMode.value) {
                              _setMapStyleLight();
                            } else {
                              _setMapStyleDark();
                            }
                            _updateCameraPosition();
                          },

                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(widget.latt ?? '0.0'),
                              double.parse(widget.lonn ?? '0.0'),
                            ),
                            zoom: _calculateZoomLevel(
                              locacontro.circleRadius.value,
                            ),
                          ),
                          zoomControlsEnabled: false,
                          circles: <Circle>{
                            Circle(
                              circleId: const CircleId('circle_id'),
                              center: LatLng(
                                double.parse(widget.latt ?? '0.0'),
                                double.parse(widget.lonn ?? '0.0'),
                              ),
                              radius: locacontro.circleRadius.value,
                              strokeWidth: 1,
                              strokeColor: Appcolors.appPriSecColor.appPrimblue
                                  .withOpacity(0.5),
                              fillColor: Appcolors.appPriSecColor.appPrimblue
                                  .withOpacity(0.2),
                            ),
                          },
                          markers: Set<Marker>.of(markerList),
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 15,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appBgColor.white
                            : Appcolors.appBgColor.darkMainBlack,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/location.png',
                            height: 20,
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.addrss.toString(),
                              style: AppTypography.text12Medium(context),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 5, bottom: 5, right: 5),
                    ).paddingSymmetric(horizontal: 20),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Container(
                          height: 105,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkMainBlack,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Appcolors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.99,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Distance Title Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/pickloc.png',
                                        height: 15,
                                        color: themeContro.isLightMode.value
                                            ? Appcolors.black
                                            : Appcolors
                                                  .appPriSecColor
                                                  .appPrimblue,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        languageController.textTranslate(
                                          "Distance",
                                        ),
                                        style: AppTypography.text12Medium(
                                          context,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  label(
                                    "${(locacontro.circleRadius.value / 100).round()} ${languageController.textTranslate("Km")}",
                                    style: AppTypography.text12Medium(context)
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue,
                                        ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 10),

                              Obx(() {
                                return SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor:
                                        Appcolors.appPriSecColor.appPrimblue,
                                    inactiveTrackColor:
                                        Appcolors.appTextColor.textLighGray,
                                    thumbColor:
                                        Appcolors.appPriSecColor.appPrimblue,
                                    overlayColor: Appcolors
                                        .appPriSecColor
                                        .appPrimblue
                                        .withOpacity(0.2),
                                    valueIndicatorColor:
                                        Appcolors.appPriSecColor.appPrimblue,
                                  ),
                                  child: Slider(
                                    value: locacontro.circleRadius.value
                                        .toDouble(),
                                    min: 5,
                                    max: _maxRadius,
                                    divisions: 95,
                                    onChanged: (double value) {
                                      locacontro.circleRadius.value = value;
                                      _updateCameraPosition();
                                    },
                                  ),
                                );
                              }),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1 ${languageController.textTranslate("Km")}',
                                    style: AppTypography.text10Medium(context)
                                        .copyWith(
                                          color: Appcolors
                                              .appTextColor
                                              .textLighGray,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  label(
                                    "${(locacontro.circleRadius.value / 100).round()}${languageController.textTranslate("Km")}",
                                    style: AppTypography.text10Medium(context)
                                        .copyWith(
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  label(
                                    "100 ${languageController.textTranslate("Km")}",
                                    style: AppTypography.text10Medium(context)
                                        .copyWith(
                                          color: Appcolors
                                              .appTextColor
                                              .textLighGray,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 10),
                            ],
                          ),
                        ).paddingSymmetric(horizontal: 15),
                        sizeBoxHeight(20),
                        CustomButtom(
                          title: languageController.textTranslate("Next"),
                          onPressed: () {
                            Get.to(
                              () => CreateAudiance(
                                addrss: widget.addrss,
                                latt: widget.latt,
                                lonn: widget.lonn,
                                serviceid: widget.serviceid,
                                vendorid: widget.vendorid,
                                distance: (locacontro.circleRadius.value / 100)
                                    .round()
                                    .toString(),
                                mindistance: '5',
                              ),
                            );
                          },
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: getProportionateScreenHeight(60),
                          width: getProportionateScreenWidth(300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        } else {
          return Center(
            child: CupertinoActivityIndicator(
              color: Appcolors.appPriSecColor.appPrimblue,
            ),
          );
        }
      },
    );
  }

  void _updateCameraPosition() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            double.parse(widget.latt ?? '0.0'),
            double.parse(widget.lonn ?? '0.0'),
          ),
          zoom: _calculateZoomLevel(locacontro.circleRadius.value),
        ),
      ),
    );
  }

  double _calculateZoomLevel(double radiusInMeters) {
    double scale = radiusInMeters / 500; // Adjust scale factor as needed
    double zoomLevel = 16 - log(scale) / log(2);
    return zoomLevel.clamp(5.0, 18.0); // Ensure zoom stays within a valid range
  }
}
