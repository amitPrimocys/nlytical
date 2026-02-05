import 'package:flutter/material.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';

class ContainerDesign extends StatefulWidget {
  const ContainerDesign({super.key});

  @override
  State<ContainerDesign> createState() => _ContainerDesignState();
}

class _ContainerDesignState extends State<ContainerDesign> {
  final serviceNameController = TextEditingController();
  final nameFocus = FocusNode();
  final nameFocus1 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Appcolors.appPriSecColor.appPrimblue,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAsstes.line_design, fit: BoxFit.cover),
              AppBar(
                title: Text('Test App'),
                elevation: 0,
                backgroundColor: Appcolors.appBgColor.transparent,
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Appcolors.white,
          ),
          child: Column(
            children: [
              globalTextField3(
                lable: "Service Name",
                lable2: " *",
                controller: serviceNameController,
                onEditingComplete: () {
                  Focus.of(context).requestFocus(nameFocus);
                },
                focusNode: nameFocus1,
                hintText: "Service Name",
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
