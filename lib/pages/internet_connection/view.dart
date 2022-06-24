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
    Provider.of<InternetConnectionProvider>(context, listen: false).listenTheStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternetConnectionProvider>();
    debugPrint('In build: ${provider.hasInternet}');
    return provider.hasInternet ? const HomePage() : const NoInternet();
  }

}

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: LottieBuilder.asset(
                  'assets/lottie/no_internet_connection.json'),
            ),
            // const SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () async {
            //     provider.hasInternet =
            //     await InternetConnectionChecker().hasConnection;
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //     shape: const StadiumBorder(),
            //   ),
            //   child: const Icon(
            //     CupertinoIcons.arrow_counterclockwise,
            //     size: 30,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
