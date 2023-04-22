import 'package:delivery_app_tutorial/common/constants/colors.dart';
import 'package:delivery_app_tutorial/common/layouts/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
        backgroundColor: uPrimaryColor,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/logo/logo.png",
                width: MediaQuery.of(context).size.width / 3 * 2,
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
