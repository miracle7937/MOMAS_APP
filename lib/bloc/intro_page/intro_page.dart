import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/request/login.dart';
import 'package:momaspayplus/screens/auth/login.dart';
import 'package:momaspayplus/utils/images.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  buildPage(
                    context,
                    image: 'assets/family.png', // replace with your asset
                    title: 'EASY AND SWIFT',
                    description:
                        'Managing your electricity bills just got easier. Pay, track, and manage all your utility payments in one place, anytime, anywhere.',
                  ),
                  buildPage(
                    context,
                    image: 'assets/thinking.png', // replace with your asset
                    title: 'FRIENDLY AND ENGAGING',
                    description:
                        'We\'re excited to have you on Momaspay. Say goodbye to long queues and missed deadlines—pay your electric bills with just a few taps. Let\'s get started!',
                  ),
                  buildPage(
                    context,
                    image: 'assets/technician.png', // replace with your asset
                    title: 'GETTING SERVICES',
                    description:
                        'Momaspay helps you easily locate the best service providers around you.',
                  ),
                ],
              ),
              // Page indicator
              Positioned(
                bottom: MediaQuery.of(context).size.height *
                    0.3, // Position it below the image section
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => buildDot(index)),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: _currentIndex == 2
            ? buildGetStartedButton(context)
            : buildNextButton(),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 12,
      width: _currentIndex == index ? 24 : 12,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget buildPage(BuildContext context,
      {required String image,
      required String title,
      required String description}) {
    return Stack(
      children: [
        // Image section
        Container(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Skip button
        Positioned(
          top: 40,
          right: 20,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        // Text and button section
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.34,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNextButton() {
    return Container(
      height: 60,
      color: Colors.green[700],
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Next'),
        ),
      ),
    );
  }

  Widget buildGetStartedButton(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.green[700],
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}
