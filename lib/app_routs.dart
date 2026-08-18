import 'package:dio_project/screen/login_screen.dart';
import 'package:dio_project/screen/product_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String login = '/login';
  static const String productsRoute = '/product';
}

final approute = GoRouter(
  initialLocation: AppRouter.login,
  routes: [

GoRoute(path: AppRouter.login, builder: (context, state) {
      return const LoginScreen();
    }),

    GoRoute(path: AppRouter.productsRoute, builder: (context, state) {
      return const ProductsScreen();
    }),
    ],
);
