import 'package:flutter/material.dart';
import 'package:google_map_integration/pages/home/view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class InternetConnectionPage extends StatefulWidget {
  const InternetConnectionPage({Key? key}) : super(key: key);

  @override
  State<InternetConnectionPage> createState() => _InternetConnectionPageState();
}

class _InternetConnectionPageState extends State<InternetConnectionPage> {
  @override
  void initState() {
    Provider.of<InternetConnectionProvider>(context, listen: false)
        .listenTheStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternetConnectionProvider>();
    debugPrint('In build: ${provider.hasInternet}');
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);
        final isWarning = now.difference(provider.lastPressed) > maxDuration;

        if (isWarning) {
          provider.updateLastTime();
          // TODO: Double Tap To Exit
          return false;
        } else {
          return true;
        }
      },
      child: provider.hasInternet ? const HomePage() : const NoInternet(),
    );
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: LottieBuilder.asset(
            'assets/lottie/no_internet_connection.json',
          ),
        ),
      ),
    );
  }
}
