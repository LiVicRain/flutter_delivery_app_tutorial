import 'package:delivery_app_tutorial/common/components/custom_text_form_field.dart';
import 'package:delivery_app_tutorial/common/providers/go_router.dart';
import 'package:delivery_app_tutorial/common/views/splash_screen.dart';
import 'package:delivery_app_tutorial/user/providers/auth_provider.dart';
import 'package:delivery_app_tutorial/user/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      // home: const SplashScreen(),
    );
  }
}
