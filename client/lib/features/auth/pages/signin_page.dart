import 'package:client/core/theme/app_colors.dart';
import 'package:client/dto/signin_user_dto.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/auth/pages/signup_page.dart';
import 'package:client/features/auth/widgets/auth_field.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:client/shared/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../main.dart';

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
                        fontWeight: FontWeight.bold)),
                        //_buildLanguagePicker(context),
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
                            AppLocalizations.of(context)!.login,
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
                          ElevatedButton(
                            onPressed: () {
                              if(formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(SignInEvent(
                                  email: emailController.text, 
                                  password: passwordController.text
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(double.maxFinite, 60),
                              backgroundColor: AppColors.pink,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.login,
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