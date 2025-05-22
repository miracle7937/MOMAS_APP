import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:shimmer/shimmer.dart';
import '../../../bloc/momas_bloc/momas_bloc.dart';
import '../../../main.dart';
import '../../../utils/amount_formatter.dart';
import '../../../utils/colors.dart';
import '../../../utils/dashboard_builder.dart';
import '../../../utils/launcher.dart';
import '../../../utils/shared_pref.dart';
import '../../../utils/strings.dart';
import '../../momos_payment/momas_payment_screen.dart';
import '../../service/service_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with RouteAware {
  late WalletBloc walletBloc;
  late PromoBloc promoBloc;
  late DashboardBloc dashboardBloc;
  late UserBloc userBloc;
  bool _isBalanceVisible = true;
  bool _isUnitVisible = true;
  User? user;
  String name = "";

  @override
  void initState() {
    super.initState();
    _load();
    walletBloc = WalletBloc(DashboardService(DashboardRepository()))
      ..add(WalletDashboardEvent());
    promoBloc = PromoBloc(DashboardService(DashboardRepository()))
      ..add(PromotionEvent());
    dashboardBloc = DashboardBloc(DashboardService(DashboardRepository()))
      ..add(FeatureDashboardEvent());
    userBloc = UserBloc(DashboardService(DashboardRepository()));
  }

  Future<void> _load() async {
    _isBalanceVisible = await SharedPreferenceHelper.getBalanceVisibility();
    _isUnitVisible = await SharedPreferenceHelper.getUnitVisibility();
    user = await SharedPreferenceHelper.getUser();
    getName(user);
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
    SharedPreferenceHelper.saveBalanceVisibility(_isBalanceVisible);
  }

  void _toggleUnitVisibility() {
    setState(() {
      _isUnitVisible = !_isUnitVisible;
    });
    SharedPreferenceHelper.saveUnitVisibility(_isUnitVisible);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    print('Screen return back');
    userBloc.add(GetUserDashboardEvent());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  getName(User? user) {
    var firstname = isEmpty(user?.firstName) ? "" : user?.firstName;
    var lastName = isEmpty(user?.lastName) ? "" : user?.lastName;
    name = "$firstname $lastName";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        walletBloc = WalletBloc(DashboardService(DashboardRepository()))
          ..add(WalletDashboardEvent());
        promoBloc = PromoBloc(DashboardService(DashboardRepository()))
          ..add(PromotionEvent());
        dashboardBloc = DashboardBloc(DashboardService(DashboardRepository()))
          ..add(FeatureDashboardEvent());
      },
      child: SafeArea(
        child: BlocProvider(
          create: (context) =>
              DashboardBloc(DashboardService(DashboardRepository())),
          child: Scaffold(
            backgroundColor: MoColors.mainColorII,
            body: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: const [0.5, 0.8],
                                colors: [
                                  MoColors.mainColor,
                                  MoColors.mainColorII,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(50)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Hi $name,",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  BlocBuilder<WalletBloc, DashboardState>(
                                      bloc: walletBloc,
                                      builder: (context, state) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            mainBalanceWidget(
                                              state is WalletLoading,
                                              (state is WalletSuccessful)
                                                  ? state.wallet.mainWallet
                                                      .toString()
                                                  : "0",
                                            ),
                                            // unitWidget(
                                            //   state is WalletLoading,
                                            //   (state is WalletSuccessful)
                                            //       ? state.wallet.unit.toString()
                                            //       : "",
                                            // )
                                          ],
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(50)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  height: 75,
                                  width: MediaQuery.of(context).size.width,
                                  child: BlocBuilder<PromoBloc, DashboardState>(
                                      bloc: promoBloc,
                                      builder: (context, state) {
                                        return SizedBox(
                                            height: 75,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: CarouselSlider(
                                              options: CarouselOptions(
                                                height: 200.0,
                                                enableInfiniteScroll: true,
                                                autoPlay: true,
                                                enlargeCenterPage: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                              items: state
                                                      is PromotionSuccessful
                                                  ? state.promo.map((value) {
                                                      return Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          return InkWell(
                                                            onTap: () => Launcher()
                                                                .launchInBrowser(
                                                                    Uri.parse(value
                                                                        .link!)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          1.0),
                                                              child:
                                                                  Image.network(
                                                                      value.url,
                                                                      fit: BoxFit
                                                                          .fill),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }).toList()
                                                  : List.generate(4,
                                                          (i) => _widgetPromo())
                                                      .map((widget) {
                                                      return Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            child: widget,
                                                          );
                                                        },
                                                      );
                                                    }).toList(),
                                            ));
                                      }),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 45,
                                ),
                                child: Text("What will you like to do?"),
                              ),
                              Expanded(
                                child: BlocBuilder<DashboardBloc,
                                        DashboardState>(
                                    bloc: dashboardBloc,
                                    builder: (context, state) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: MoColors.mainColor
                                                  .withOpacity(0.01)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            child: GridView.count(
                                              crossAxisCount: 3,
                                              childAspectRatio: .8,
                                              crossAxisSpacing: 12.0,
                                              mainAxisSpacing: 12.0,
                                              padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  right: 12.0,
                                                  top: 12.0,
                                                  bottom: 100),
                                              children: state
                                                      is FeaturesSuccessful
                                                  ? DashboardBuilder.builder(
                                                          state.feature,
                                                          context,
                                                          user!)
                                                      .map((value) => _GridItem(
                                                            image: value.image,
                                                            title: value.title,
                                                            subtitle:
                                                                value.subtitle,
                                                            onTap: value.onTap,
                                                          ))
                                                      .toList()
                                                  : _buildShimmerItems(),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: constraints.maxHeight * 0.17,
                      left: (constraints.maxWidth / 2) -
                          MediaQuery.of(context).size.width * 0.4,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                offset: Offset(4, 4),
                                blurRadius: 15),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            quickWidget(
                                title: "Buy Units",
                                image: MoImage.momasPayment,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const MomasPaymentScreen(
                                                momasPaymentType:
                                                    MomasPaymentType.self,
                                              )));
                                }),
                            // quickWidget(
                            //     title: "Fund Wallet",
                            //     image: MoImage.topUpWallet),
                            quickWidget(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const ServiceScreen()));
                                },
                                title: "Services",
                                image: MoImage.services),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _widgetPromo() {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          height: 75,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }

  Widget quickWidget(
      {required String image, String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(4, 4),
                blurRadius: 15),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 25, height: 25, child: Image.asset(image)),
              const SizedBox(
                width: 5,
              ),
              Text(
                title ?? "",
                style: const TextStyle(fontSize: 8),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mainBalanceWidget(bool isLoading, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Main Wallet",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            const Icon(
              Icons.wallet_outlined,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _isBalanceVisible
                  ? AmountFormatter.formatNaira(double.parse(amount))
                  : "***",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                _toggleBalanceVisibility();
              },
              child: Icon(
                _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget unitWidget(bool isLoading, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Units",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            const Icon(
              Icons.bolt,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: Text(
                _isUnitVisible ? unit : "******",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                _toggleUnitVisibility();
              },
              child: Icon(
                _isUnitVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> _buildShimmerItems() {
    return List.generate(9, (index) => _buildShimmerItem());
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(8.0),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _GridItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(4, 4),
                blurRadius: 15),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 8.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 7.0,
                      color: Colors.grey,
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
