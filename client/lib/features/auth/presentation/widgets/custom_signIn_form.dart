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
      if (next.error != null) {
        Fluttertoast.showToast(
          msg: next.error!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        authNotifier.clearError();
      }

      if (next.isAuthenticated && !next.isLoading) {
        Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Navigate to home page after successful login
        customReplacementNavigation(context, "/home");
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
