import 'package:flutter/material.dart';

class PopButton{

  pop(BuildContext context){
    return InkWell(
      onTap: ()=>Navigator.pop(context),
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );

  }
}