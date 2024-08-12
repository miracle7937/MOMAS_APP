
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/colors.dart';

// class MoButton extends StatefulWidget {
//   const MoButton({super.key,  this.isLoading=false, required this.title, required this.onTap});
//   final bool? isLoading;
//   final String title;
//   final Function() onTap;
//   @override
//   State<MoButton> createState() => _MoButtonState();
// }
//
// class _MoButtonState extends State<MoButton> {
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 50,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           gradient: LinearGradient(
//             colors: [MoColors.mainColor,MoColors.mainColorII ],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//         ),
//         child: Center(
//           child: widget.isLoading!
//               ? const SpinKitFadingCircle(
//             color: Colors.white,
//             size: 30.0,
//           )
//               :  Text(
//             widget.title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




class MoButton extends StatefulWidget {
  const MoButton({
    super.key,
    this.isLoading = false,
    required this.title,
    required this.onTap,
  });

  final bool? isLoading;
  final String title;
  final Function() onTap;

  @override
  State<MoButton> createState() => _MoButtonState();
}

class _MoButtonState extends State<MoButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading! ? null : widget.onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          width: widget.isLoading! ? 50 : MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.isLoading! ? 25 : 10),
            gradient: LinearGradient(
              colors: [MoColors.mainColor, MoColors.mainColorII],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: widget.isLoading! ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              if (widget.isLoading!)
                const SpinKitFadingCircle(
                  color: Colors.white,
                  size: 30.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

