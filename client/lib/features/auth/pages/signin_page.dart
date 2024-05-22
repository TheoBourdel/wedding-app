import 'package:client/core/theme/app_colors.dart';
import 'package:client/dto/signin_user_dto.dart';
import 'package:client/features/auth/pages/signup_page.dart';
import 'package:client/features/auth/widgets/auth_field.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:client/shared/widget/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthRepository authRepository = AuthRepository();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void handleSignIn() async {
    if (formKey.currentState!.validate()) {
      
      SignInUserDto user = SignInUserDto(
        email: emailController.text,
        password: passwordController.text,
      );
      
      try {
        String token = await authRepository.signIn(user);

        // Save token in shared preferences (local storage)
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => NavigationMenu(token: token)
          )
        );
      } catch (e) {
        // Show error toast
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.pink,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthField(hintText: 'Email', controller: emailController),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true
                      ),                      
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: handleSignIn,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(double.maxFinite, 60),
                          backgroundColor: AppColors.pink,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            color: AppColors.textIcons,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Pas encore de compte ?',
                            style: TextStyle(
                              color: AppColors.mediumPink,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                            child: const Text(
                              'Inscris-toi',
                              style: TextStyle(
                                color: AppColors.pink,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  ),
                )
              )
            )
          ],
        )
      ),
    );
  }
}