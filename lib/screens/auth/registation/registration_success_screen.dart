

import 'package:flutter/material.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:momas_pay/utils/images.dart';

import '../../../reuseable/mo_button.dart';
import '../login.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: MoColors.mainColorII.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
                child: Lottie.asset(MoImage.lottieSuccess, repeat: false)),
            const SizedBox(height: 20,),
            const Text("Awesome!", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 20),)  ,
            const SizedBox(height: 20,),

            const Text("Your account has been successfully created",
              style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.w200, fontSize: 13),),
            const SizedBox(height: 20,),
            Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: MoButton(
                      title: "LOGIN",
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                            builder: (context) => const LoginScreen()), (Route route) => false);
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
