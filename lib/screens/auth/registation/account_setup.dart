

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/domain/data/request/register.dart';
import 'package:momas_pay/screens/auth/registation/registration_success_screen.dart';


import '../../../bloc/registeration_bloc/register_bloc.dart';
import '../../../bloc/registeration_bloc/register_event.dart';
import '../../../bloc/registeration_bloc/register_state.dart';
import '../../../domain/repository/auth_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../../reuseable/error_modal.dart';
import '../../../reuseable/mo_button.dart';
import '../../../reuseable/mo_form.dart';
import '../../../reuseable/pop_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key, required this.email});
  final String email;

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController meterNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    meterNoController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: MoColors.mainColorII ,
        body: BlocProvider(
          create: (context) => RegisterBloc(AuthService(AuthRepository())),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.15,
                        decoration: BoxDecoration(
                          gradient:  LinearGradient(
                            stops: const [0.5, 0.8],
                            colors: [
                              MoColors.mainColor,
                              MoColors.mainColorII,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(100)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              Row(children: [  PopButton().pop(context), const Spacer(), Center(child: Image.asset(MoImage.logo, width: 50,)),],),
                              const SizedBox(height: 10,),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Set up Account", style: TextStyle(fontSize: 20, color: Colors.white),),
                                ],
                              ),
                              const SizedBox(height:10 ,),
                            ],
                          ),
                        ),

                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height*0.8,
                      decoration:  const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
                      ),
                      child:    Column(
                        children: [
                          const SizedBox(height: 50,),
                           MoFormWidget(
                             controller: firstNameController,
                            prefixIcon: const Icon(Icons.person, color: Colors.grey,),
                            title: "First Name", ),
                          MoFormWidget(
                            controller: lastNameController,
                            prefixIcon: const Icon(Icons.person, color: Colors.grey,),
                            title: "Last Name", ),
                           MoFormWidget(
                             controller: meterNoController,
                            prefixIcon: const Icon(Icons.electric_meter, color: Colors.grey,),
                            title: "Meter Number", ),
                           MoFormWidget(
                             controller: phoneController,
                            prefixIcon: const Icon(Icons.phone, color: Colors.grey,),
                            title: "Phone No", ),
                           MoFormWidget(
                            controller: passwordController,
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey,),
                            title: "Password", isPassword: true, ),
                           MoFormWidget(
                            controller: confirmPasswordController,
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey,),
                            title: "Confirm password",  isPassword: true,),
                          const SizedBox(height: 20,),
                          Padding(
                            padding:  const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MoButton(
                                    isLoading: context.watch<RegisterBloc>().state is RegisterLoading,
                                    title: "CONTINUE",
                                    onTap: (){
                                      Register register = Register(firstName: firstNameController.text, lastName: lastNameController.text,
                                          meterNo: meterNoController.text,
                                          phone: phoneController.text,
                                          email:  widget.email,
                                          password: passwordController.text,
                                          confirmPassword: confirmPasswordController.text);
                                          context.read<RegisterBloc>().add(UserRegisterEvent(register));

                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(height: 20,)
                        ],),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, RegisterState state) {
              switch (state) {
                case RegisterProcessFailure():
                  showErrorBottomSheet(context, state.error);
                case RegisterSuccess():
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const RegistrationSuccessScreen()));
                default:
                  log("state not implemented");
              }

          },
          ),
        ),
      ),
    );
  }

}
