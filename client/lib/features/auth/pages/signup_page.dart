import 'package:client/core/theme/app_colors.dart';
import 'package:client/dto/signup_user_dto.dart';
import 'package:client/features/auth/widgets/auth_field.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:client/core/error/failure.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  final AuthRepository authRepository = AuthRepository();

  String selectedRole = "";
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
        role: selectedRole,
      );
      try {
        await authRepository.signUp(user);
        
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context) => const SignInPage()
          ),
        );
      } catch (e) {
        print(e);
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
                       Text(
                        AppLocalizations.of(context)!.register,
                        style: const TextStyle(
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
                      DropdownButtonFormField(
                        isExpanded: false,
                        iconEnabledColor: AppColors.pink,
                        hint: const Text(
                          'Séléctionne ton type de compte',
                          style: TextStyle(
                            color: AppColors.mediumPink,
                            fontSize: 16,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        items: const [
                          DropdownMenuItem(
                            value: "provider",
                            child: Text('Prestataire'),
                          ),
                          DropdownMenuItem(
                            value: "marry",
                            child: Text('Marié(e)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                              selectedRole = value as String;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: handleSignUp,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(double.maxFinite, 60),
                          backgroundColor: AppColors.pink,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          style: const TextStyle(
                            color: Colors.white,
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
                            'Tu as déjà un compte ? ',
                            style: TextStyle(
                              color: AppColors.mediumPink,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SignInPage()),
                              );
                            },
                            child: const Text(
                              'Connecte-toi',
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
      )
    );
  }
}
