import 'package:flutter/material.dart';
import 'package:google_map_integration/pages/home/view.dart';
import 'package:google_map_integration/pages/internet_connection/view.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const InternetConnectionPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: LottieBuilder.asset('assets/lottie/map-luminased.json'),
        ),
      ),
    );
  }
}
