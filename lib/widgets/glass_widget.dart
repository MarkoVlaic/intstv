import 'dart:ui';

import 'package:flutter/material.dart';

class GlassWidget extends StatelessWidget {
  const GlassWidget(
      {super.key,
      required this.childWidget,
      this.margin,
      this.sigmaX,
      this.sigmaY,
      this.circularRadius,
      this.gradientColors,
      this.backgroundColor,
      this.widgetWidth,
      this.padding,
      this.contentPadding});

  final Widget childWidget;

  final EdgeInsets? margin, padding, contentPadding;
  final double? sigmaX, sigmaY, circularRadius, widgetWidth;
  final List<Color>? gradientColors;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: widgetWidth,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circularRadius ?? 30),
        child: Container(
          color: backgroundColor ?? Colors.white.withOpacity(.3),
          child: Stack(
            children: [
              // blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigmaX ?? 10, sigmaY: sigmaY ?? 10),
                child: Container(),
              ),
              //gradient effect
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circularRadius ?? 30),
                  border: Border.all(color: Colors.white.withOpacity(.13)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors ??
                        [
                          Colors.white.withOpacity(.15),
                          Colors.white.withOpacity(.07),
                        ],
                  ),
                ),
              ),
              //child
              Center(
                child: Container(
                  padding: contentPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: childWidget,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
