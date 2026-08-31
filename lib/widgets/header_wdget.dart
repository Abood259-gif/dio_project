import 'dart:async';

import 'package:dio_project/app_routs.dart';
import 'package:dio_project/provider/auth/auth_provider.dart';
import 'package:dio_project/provider/search_products_provider.dart';
import 'package:dio_project/provider/upload_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class HeaderWdget extends ConsumerStatefulWidget {
  const HeaderWdget({super.key});
  @override
  ConsumerState<HeaderWdget> createState() => HeaderWdgetState();
}

class HeaderWdgetState extends ConsumerState<HeaderWdget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  void onSearchChanged(String value) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  Future<void> _handleImagePick() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    await ref.read(authNotifierProvider.notifier).updateProfileImage(bytes);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
   final userState = ref.watch(userStateChangesProvider);
    
    // Read the current user's photo URL from the stream
    final userPhotoUrl = userState.value?.photoUrl;
    final isLoading = authState.isLoading;

    // Show SnackBars on errors automatically
    ref.listen<AsyncValue<void>>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Operation failed: ${next.error}')),
        );
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore',
          style: TextStyle(
            color: Color(0xFF818181),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Expanded(
              child: Text(
                'All Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
            ),
            
            // Profile Image CircleAvatar
            GestureDetector(
              onTap: isLoading ? null : _handleImagePick,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF2D2D2D),
                    backgroundImage: userPhotoUrl != null && userPhotoUrl.isNotEmpty
                        ? NetworkImage(userPhotoUrl)
                        : null,
                    child: userPhotoUrl == null || userPhotoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          )
                        : null,
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Logout Button
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF2A2A2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(color: Color(0xFFB0B0B0)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFFB0B0B0)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && mounted) {
                    context.go(AppRouter.login);
                    ref.read(authNotifierProvider.notifier).logout();
                  }
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _searchController,
          onChanged: (value) {
            onSearchChanged(value);
            final currentRoute = GoRouterState.of(context).uri.toString();
            if (value.trim().isNotEmpty) {
              if (currentRoute != AppRouter.searchRoute) {
                context.go(AppRouter.searchRoute);
              }
            } else {
              if (currentRoute == AppRouter.searchRoute) {
                context.go(AppRouter.productsRoute);
              }
            }
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: const TextStyle(color: Color(0xFF8B8B8B)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF8B8B8B)),
            filled: true,
            fillColor: const Color(0xFF2D2D2D),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3B3B3B)),
              borderRadius: BorderRadius.circular(18),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF5A5A5A)),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}