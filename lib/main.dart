import 'package:dttassessment/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dttassessment/theme/colors.dart';

void main() {
  runApp(MaterialApp(
    title: 'Splash Screen Example',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MyApp> {
  AppColors appColors = AppColors();
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  Future<void> navigateToHome() async {
    // Simulate a delay for the splash screen
    await Future.delayed(Duration(seconds: 2));
    // Navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.dttRed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //DTT Logo
            SvgPicture.asset(
              'assets/Icons/ic_dtt.svg',
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
