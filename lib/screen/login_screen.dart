import 'package:dio_project/app_routs.dart';
import 'package:dio_project/provider/auth/auth_provider.dart';
import 'package:dio_project/widgets/login_button.dart';
import 'package:dio_project/widgets/login_card.dart';
import 'package:dio_project/widgets/login_heder.dart';
import 'package:dio_project/widgets/login_section_divider.dart';
import 'package:dio_project/widgets/login_social_butoon.dart';
import 'package:dio_project/widgets/login_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio_project/provider/auth/authe_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (state) {
          if (state is AuthAuthenticated) {
            context.go(AppRouter.productsRoute);
          }
        },
      );
    });

    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCompact = constraints.maxWidth < 460;
          final bool isVeryNarrow = constraints.maxWidth < 360;
          final double maxCardWidth = constraints.maxWidth > 900 ? 600 : 540;
          
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 14 : 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxCardWidth),
                  child: LoginCard(
                    padding: EdgeInsets.all(isCompact ? 20 : 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginHeader(
                          title: 'Welcome back',
                          subtitle: 'Sign in to your account',
                          icon: Icons.shopping_bag_outlined,
                          boxSize: isCompact ? 84 : 96,
                          iconSize: isCompact ? 38 : 44,
                          titleFontSize: isCompact ? 38 : 52,
                          subtitleFontSize: isCompact ? 16 : 18,
                        ),
                        SizedBox(height: isCompact ? 28 : 34),
                        LoginTextField(
                          label: 'Email address',
                          hintText: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2F66E4),
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: isVeryNarrow ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LoginTextField(
                          hintText: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(height: 28),
                        if (authState.isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2F66E4),
                            ),
                          )
                        else
                          LoginPrimaryButton(
                            text: 'Sign in',
                            onPressed: () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              if (email.isNotEmpty && password.isNotEmpty) {
                                ref.read(authNotifierProvider.notifier).login(
                                      email: email,
                                      password: password,
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter both email and password'),
                                  ),
                                );
                              }
                            },
                          ),
                        const SizedBox(height: 28),
                        const LoginSectionDivider(text: 'or continue with'),
                        const SizedBox(height: 24),
                        if (isVeryNarrow) ...[
                          LoginSocialButton(
                            label: 'Google',
                            leading: const Text(
                              'G',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(height: 12),
                          LoginSocialButton(
                            label: 'Apple',
                            leading: const Icon(Icons.apple, size: 26),
                            onPressed: () {},
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: LoginSocialButton(
                                  label: 'Google',
                                  leading: const Text(
                                    'G',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: LoginSocialButton(
                                  label: 'Apple',
                                  leading: const Icon(Icons.apple, size: 24),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                             
                            },
                            child: Text.rich(
                              TextSpan(
                                text: 'Don\'t have an account? ',
                                style: const TextStyle(
                                  color: Color(0xFFA0A0A0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                      color: Color(0xFF2F66E4),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}