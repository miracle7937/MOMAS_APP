import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/screens/auth/login.dart';
import 'package:momas_pay/utils/navigation.dart';
import 'package:momas_pay/utils/shared_pref.dart';

import 'package:momas_pay/utils/theme.dart';

import 'bloc/intro_page/intro_page.dart';
import 'bloc/registeration_bloc/register_bloc.dart';
import 'bloc/setting_bloc/setting_bloc.dart';
import 'domain/data/response/user_model.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/repository/setting_repository.dart';
import 'domain/service/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Momas Pay',
      theme: ThemeConfig.buildCustomTheme(),
      home: const MyHomePage(title: 'Momas Pay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: SharedPreferenceHelper.getUser(),
        builder: (context, snapshot) {
          return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      RegisterBloc(AuthService(AuthRepository())),
                ),
              ],
              child: snapshot.data == null
                  ? const IntroPage()
                  : const LoginScreen());
        });
    // child: const LoginScreen());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
