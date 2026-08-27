import 'package:dio_project/screen/login_screen.dart';
import 'package:dio_project/screen/product_screen.dart';
import 'package:dio_project/screen/search_screen.dart';
import 'package:dio_project/widgets/shell_widget.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String login = '/login';
  static const String productsRoute = '/product';
  static const String searchRoute = '/search';
}

final approute = GoRouter(
  initialLocation: AppRouter.login,
  routes: [

GoRoute(path: AppRouter.login, builder: (context, state) {
      return const LoginScreen();
    }),
    ShellRoute(
      builder: (context, state, child) {
        return ShellWidget(child: child);
      },
      routes: [
        GoRoute(
          path: AppRouter.searchRoute
          ,
          builder: (context, state) {
            return const SearchScreen();
          },
        ),
        GoRoute(path: AppRouter.productsRoute, builder: (context, state) {
          return const ProductsScreen();
        }),
    ],
    ),
  ],

);
