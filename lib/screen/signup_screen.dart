import 'package:dio_project/app_routs.dart';
import 'package:dio_project/provider/auth/auth_provider.dart';
import 'package:dio_project/widgets/login_button.dart';
import 'package:dio_project/widgets/login_card.dart';
import 'package:dio_project/widgets/login_heder.dart';
import 'package:dio_project/widgets/login_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCompact = constraints.maxWidth < 460;
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
                          title: 'Create Account',
                          subtitle: 'Join us today!',
                          icon: Icons.person_add_outlined,
                          boxSize: isCompact ? 84 : 96,
                          iconSize: isCompact ? 38 : 44,
                          titleFontSize: isCompact ? 38 : 46,
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
                        LoginTextField(
                          label: 'Password',
                          hintText: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(height: 22),
                        LoginTextField(
                          label: 'Confirm Password',
                          hintText: '••••••••',
                          controller: _confirmPasswordController,
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
                            text: 'Sign up',
                            onPressed: () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              final confirmPassword = _confirmPasswordController
                                  .text
                                  .trim();

                              if (email.isEmpty ||
                                  password.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                  ),
                                );
                                return;
                              }

                              if (password != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Passwords do not match'),
                                  ),
                                );
                                return;
                              }

                              ref
                                  .read(authNotifierProvider.notifier)
                                  .signup(email: email, password: password);
                            },
                          ),
                        const SizedBox(height: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.go(AppRouter.login);
                            },
                            child: Text.rich(
                              TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(
                                  color: Color(0xFFA0A0A0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Sign in',
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
