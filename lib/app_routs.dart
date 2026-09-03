import 'package:dio_project/screen/favorites_screen.dart';
import 'package:dio_project/screen/login_screen.dart';
import 'package:dio_project/screen/product_screen.dart';
import 'package:dio_project/screen/search_screen.dart';
import 'package:dio_project/screen/signup_screen.dart';
import 'package:dio_project/widgets/shell_widget.dart';
import 'package:dio_project/provider/auth/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String productsRoute = '/product';
  static const String searchRoute = '/search';
  static const String favoritesRoute = '/favorites';
}

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final authState = ref.watch(authstateChange);

  return GoRouter(
    initialLocation: AppRouter.login,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoggingIn =
          state.matchedLocation == AppRouter.login ||
          state.matchedLocation == AppRouter.signup;

      if (!isLoggedIn && !isLoggingIn) return AppRouter.login;
      if (isLoggedIn && isLoggingIn) return AppRouter.productsRoute;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRouter.login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRouter.signup,
        builder: (context, state) {
          return const SignupScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellWidget(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.productsRoute,
                builder: (context, state) {
                  return const ProductsScreen();
                },
              ),
              GoRoute(
                path: AppRouter.searchRoute,
                builder: (context, state) {
                  return const SearchScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.favoritesRoute,
                builder: (context, state) {
                  return const FavoritesScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
