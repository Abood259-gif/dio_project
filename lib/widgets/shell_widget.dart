import 'package:dio_project/app_routs.dart';
import 'package:dio_project/widgets/header_wdget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellWidget extends StatelessWidget {
  const ShellWidget({super.key, required this._child});
  final Widget _child;

  int _indexForLocation(String location) {
    if (location.startsWith(AppRouter.favoritesRoute)) return 1;
    return 0; // default: products / search tab
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.productsRoute);
        break;
      case 1:
        context.go(AppRouter.favoritesRoute);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const HeaderWdget(),
              Expanded(child: _child),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onTap(context, index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF6C63FF),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}