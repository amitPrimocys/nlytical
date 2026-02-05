// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:nlytical/utils/colors.dart';
// import 'package:nlytical_vendor/utils/colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;
  String switch1 = '';

  String switch2 = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _circleAnimation =
        AlignmentTween(
          begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
          end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
        ).animate(
          CurvedAnimation(parent: _animationController!, curve: Curves.linear),
        );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 46.0,
            height: 25.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: _circleAnimation!.value == Alignment.centerLeft
                    ? Appcolors.white
                    : Appcolors.appPriSecColor.appPrimblue,
              ),
              borderRadius: BorderRadius.circular(24.0),
              // color: Appcolors.appPriSecColor.appPrimblue
              color: _circleAnimation!.value == Alignment.centerLeft
                  ? Appcolors.darkMainBlack
                  : Appcolors.appPriSecColor.appPrimblue,
              // _circleAnimation!.value == Alignment.centerLeft
              //     ? const Color.fromRGBO(150, 182, 218, 1)
              //     : Appcolors.appPriSecColor.appPrimblue
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2.0,
                bottom: 2.0,
                right: 1.0,
                left: 1.0,
              ),
              child: Container(
                alignment: widget.value
                    ? ((Directionality.of(context) == TextDirection.rtl)
                          ? Alignment.centerLeft
                          : Alignment.centerRight)
                    : ((Directionality.of(context) == TextDirection.rtl)
                          ? Alignment.centerRight
                          : Alignment.centerLeft),
                child: Container(
                  width: 22.0,
                  height: 22.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Appcolors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
