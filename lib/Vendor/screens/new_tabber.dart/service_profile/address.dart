// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  StoreController storeController = Get.find();
  final addressController = TextEditingController();

  final addressFocus = FocusNode();
  final addressFocus1 = FocusNode();

  @override
  void initState() {
    addressController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.address ?? ''
        : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: appbarTitle(
            context,
            title: languageController.textTranslate("Business Address"),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeBoxHeight(30),
              businessTitle(
                context,
                title: languageController.textTranslate("Business Address"),
              ),
              sizeBoxHeight(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: themeContro.isLightMode.value
                        ? Appcolors.appPriSecColor.appPrimblue
                        : Appcolors.white,
                    size: 15,
                  ),
                  Flexible(
                    child: businessSubTitle(
                      context,
                      title:
                          " ${languageController.textTranslate("Enter the address details that would be used by customers to locate your workplace")}",
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(20),
              globalTextField(
                lable: languageController.textTranslate("Business Address"),
                lable2: " *",
                maxLines: 4,
                controller: addressController,
                onChanged: (p0) async {
                  setState(() {});
                  if (p0.isNotEmpty) {
                    await storeController.getsuggestion(p0);
                    setState(() {});
                  } else {
                    storeController.mapresult.clear();
                    setState(() {});
                  }
                  setState(() {});
                },
                isEmail: false,
                isNumber: false,
                onEditingComplete: () async {
                  Focus.of(context).requestFocus(addressFocus);
                  // If user typed a full address manually and didn't select a suggestion
                  if (storeController.mapresult.isEmpty) {
                    await storeController.getLonLat(addressController.text);
                  }
                },
                isOnlyRead: isDemo == "false" ? false : true,
                onTap: () {
                  if (isDemo == "true") {
                    snackBar("This is for demo, We can not allow to edit");
                  }
                },
                focusNode: addressFocus1,
                hintText: languageController.textTranslate("Business Address"),
                context: context,
              ),
              addressController.text.isEmpty ||
                      storeController.mapresult.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: storeController.mapresult.length,
                        itemBuilder: (context, index) {
                          final suggestion =
                              storeController.mapresult[index]['description'];
                          return InkWell(
                            onTap: () async {
                              addressController.text = suggestion;
                              storeController.mapresult.clear();
                              setState(() {});

                              await storeController.getLonLat(suggestion);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 12,
                                bottom:
                                    index ==
                                        storeController.mapresult.length - 1
                                    ? 0
                                    : 15,
                              ),
                              child: Text(suggestion),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return storeController.isUpdate.value
            ? SizedBox(
                height: 50,
                width: 50,
                child: Center(child: commonLoading()),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 20,
                right: 20,
              )
            : customBtn(
                onTap: () {
                  if (isDemo == "false") {
                    if (addressController.text.trim().isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please add your business address",
                        ),
                      );
                    } else {
                      (storeController.searchLatitude.toString());
                      (storeController.searchLongitude.toString());
                      storeController.storeAddressUpdateApi(
                        address: addressController.text,
                        lat: storeController.searchLatitude.toString(),
                        long: storeController.searchLongitude.toString(),
                      );
                    }
                  } else {
                    snackBar("This is for demo, We can not allow to update");
                  }
                },
                title: languageController.textTranslate("Save"),
                fontSize: 15,
                weight: FontWeight.w400,
                radius: BorderRadius.circular(10),
                width: getProportionateScreenWidth(260),
                height: getProportionateScreenHeight(55),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 60,
                right: 60,
              );
      }),
    );
  }
}
