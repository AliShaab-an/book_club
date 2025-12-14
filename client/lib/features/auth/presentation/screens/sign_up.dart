import 'package:client/core/functions/navigation.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/auth/presentation/widgets/custom_signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/have_an_account.dart';
import '../widgets/welcome_text.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: const SizedBox(height: 80)),
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Pallete.greenColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 50,
                        color: Pallete.greenColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeTextWidget(text: "Welcome!"),
                  SizedBox(height: 8),
                  Text(
                    "Create an account to join book clubs",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: CustomSignupForm()),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: HaveAnAccount(
                text1: "Already have an Account? ",
                text2: "Sign In",
                onTap: () {
                  customReplacementNavigation(context, "/login");
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
