import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/auth/dto/signup_user_dto.dart';
import 'package:client/features/auth/model/user.dart';
import 'package:client/features/auth/presentation/widgets/auth_field.dart';
import 'package:client/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  final AuthRepository authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  handleSignUp() async {
    if (formKey.currentState!.validate()) {
      SignUpUserDto user = SignUpUserDto(
        email: emailController.text,
        password: passwordController.text,
      );

      try {
        User signedUpUser = await authRepository.signUp(user);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPink,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png',
                    width: 100, 
                    height: 100
                  ),
                  const Text('Weddy',
                    style: TextStyle(
                    fontSize: 30,
                    color: AppColors.pink,
                    fontWeight: FontWeight.bold))
                ],
              )),
            ),
            Expanded(
              flex: 2,
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthField(hintText: 'Email', controller: emailController),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true
                      ),
                      ElevatedButton(
                        onPressed: handleSignUp,
                        child: const Text('Sign Up')
                      ),
                    ],
                  ),
                )
              )
            )
          ],
        )
      )
    );
  }
}
