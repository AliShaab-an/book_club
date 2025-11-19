import 'package:client/core/functions/navigation.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_notifier.dart';
import 'package:client/features/auth/presentation/widgets/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomSignupForm extends ConsumerStatefulWidget {
  const CustomSignupForm({super.key});

  @override
  ConsumerState<CustomSignupForm> createState() => _CustomSignupFormState();
}

class _CustomSignupFormState extends ConsumerState<CustomSignupForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validate field values
    if (_firstName.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "First name is required");
      return;
    }
    if (_lastName.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Last name is required");
      return;
    }
    if (_email.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Email is required");
      return;
    }
    if (_password.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
      return;
    }

    // Call sign up
    await ref
        .read(authNotifierProvider.notifier)
        .signUp(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

    // Check result
    final authState = ref.read(authNotifierProvider);
    if (authState.error != null) {
      Fluttertoast.showToast(
        msg: authState.error!,
        backgroundColor: Colors.red,
      );
    } else if (authState.isAuthenticated) {
      Fluttertoast.showToast(
        msg: "Sign up successful!",
        backgroundColor: Colors.green,
      );
      if (mounted) {
        customReplacementNavigation(context, "/home");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomField(labelText: "First Name", controller: _firstName),
          CustomField(labelText: "Last Name", controller: _lastName),
          CustomField(labelText: "Email", controller: _email),
          CustomField(
            labelText: "Password",
            controller: _password,
            isObscureText: true,
          ),
          const TermsAndCondition(),
          const SizedBox(height: 55),
          CustomButton(
            text: authState.isLoading ? "Signing Up..." : "Sign Up",
            onTap: authState.isLoading
                ? () {} // Disable button when loading
                : () => _handleSignUp(),
            color: Pallete.greenColor,
          ),
        ],
      ),
    );
  }
}
