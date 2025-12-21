import 'package:client/core/functions/navigation.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_notifier.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'forget_password_text_widget.dart';

class CustomSignInForm extends ConsumerStatefulWidget {
  const CustomSignInForm({super.key});

  @override
  ConsumerState<CustomSignInForm> createState() => _CustomSignInFormState();
}

class _CustomSignInFormState extends ConsumerState<CustomSignInForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _hasShownSuccessToast = false;

  @override
  void initState() {
    super.initState();
    // Reset authentication state when login page loads
    // This ensures we can detect the transition from false to true
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).signOut();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      print(
        'DEBUG Listener: previous auth=${previous?.isAuthenticated}, next auth=${next.isAuthenticated}, loading=${next.isLoading}, error=${next.error}',
      );

      // Show error toast only when error changes from null to non-null
      if (next.error != null && previous?.error != next.error) {
        Fluttertoast.showToast(
          msg: next.error!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        // Clear error after showing
        Future.delayed(const Duration(milliseconds: 100), () {
          authNotifier.clearError();
        });
      }

      // Only show success toast when transitioning from unauthenticated to authenticated
      // Check: authenticated, not loading, previous exists and was not authenticated (or was loading)
      if (next.isAuthenticated &&
          !next.isLoading &&
          !_hasShownSuccessToast &&
          (previous == null ||
              !previous.isAuthenticated ||
              previous.isLoading)) {
        print('DEBUG Listener: Navigation triggered!');
        _hasShownSuccessToast = true;
        Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Navigate to home page after successful login
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            print('DEBUG Listener: Calling navigation to /home');
            customReplacementNavigation(context, "/home");
          } else {
            print('DEBUG Listener: Context not mounted!');
          }
        });
      } else {
        print(
          'DEBUG Listener: Navigation NOT triggered - auth=${next.isAuthenticated}, loading=${next.isLoading}, hasShown=$_hasShownSuccessToast, prevAuth=${previous?.isAuthenticated}',
        );
      }
    });

    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomField(labelText: "Email", controller: _email),
          CustomField(
            labelText: "Password",
            controller: _password,
            isObscureText: true,
          ),
          const SizedBox(height: 16),
          const ForgetPasswordWidget(),
          const SizedBox(height: 55),
          CustomButton(
            text: authState.isLoading ? "Signing In..." : "Sign In",
            onTap: () {
              if (authState.isLoading) return;

              // Dismiss keyboard
              FocusScope.of(context).unfocus();

              if (formKey.currentState!.validate()) {
                // Additional validation
                if (!RegExp(
                  r'^[^@]+@[^@]+\.[^@]+',
                ).hasMatch(_email.text.trim())) {
                  Fluttertoast.showToast(
                    msg: "Please enter a valid email",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                if (_password.text.length < 6) {
                  Fluttertoast.showToast(
                    msg: "Password must be at least 6 characters",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                authNotifier.signIn(
                  email: _email.text.trim(),
                  password: _password.text,
                );
              }
            },
            color: Pallete.greenColor,
          ),
        ],
      ),
    );
  }
}
