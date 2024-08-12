


import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final Color?  color;
  const ShadowContainer({super.key, required this.child,  this.borderRadius,  this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:color?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(1, 2),
              blurRadius: 15
          ),
        ],
      ),
      child: child,
    );
  }
}
