import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authBloc/auth_bloc.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  void _onSignupPressed(BuildContext context) {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    _controller.forward().then((_) => _controller.reverse());
    context.read<AuthBloc>().add(SignupRequested(
        email: emailController.text, password: passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthSuccess) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) =>  HomeScreen(userId: state.user.email,)),
            );
          } else if (state is AuthFailure) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text("Create Account",
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                CustomTextField(controller: nameController, hintText: 'Name'),
                const SizedBox(height: 20),
                CustomTextField(controller: emailController, hintText: 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                CustomTextField(controller: phoneController, hintText: 'Phone', keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                CustomTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                const SizedBox(height: 20),
                CustomTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true),
                const SizedBox(height: 30),
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
                  child: CustomButton(
                    text: "Sign Up",
                    onPressed: () => _onSignupPressed(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
