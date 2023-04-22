import 'package:delivery_app_tutorial/common/views/root_tab.dart';
import 'package:delivery_app_tutorial/common/views/splash_screen.dart';
import 'package:delivery_app_tutorial/restaurant/views/restaurant_detail_screen.dart';
import 'package:delivery_app_tutorial/user/models/user_model.dart';
import 'package:delivery_app_tutorial/user/providers/user_me_provider.dart';
import 'package:delivery_app_tutorial/user/views/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (context, state) => const RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                name: RestaurantDetailScreen.routeName,
                builder: (context, state) => RestaurantDetailScreen(
                  id: state.params['rid']!,
                ),
              ),
            ]),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // redirect logic
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';

    if (user == null) {
      return logginIn ? null : '/login';
    }

    // UserModel 인 상태
    if (user is UserModel) {
      // 로그인중이거나 slashScreen 일때 홈으로 이동
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError 일때
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null; // 원래 가던곳으로 보내기
  }
}
