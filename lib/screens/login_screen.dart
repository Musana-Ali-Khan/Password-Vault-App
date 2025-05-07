import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/screens/signup_screen.dart';
import '../bloc/authBloc/auth_bloc.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  void _onLoginPressed(BuildContext context) {
    _controller.forward().then((_) => _controller.reverse());
    context.read<AuthBloc>().add(LoginRequested(
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
              builder: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is AuthSuccess) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen(userId: state.user.email,)),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome Back!",
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() => rememberMe = value ?? false);
                    },
                  ),
                  const Text("Remember me")
                ],
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
                child: CustomButton(
                  text: "Login",
                  onPressed: () => _onLoginPressed(context),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                child: const Text("Don't have an account? Sign up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
