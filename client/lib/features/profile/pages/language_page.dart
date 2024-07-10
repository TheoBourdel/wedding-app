import 'package:client/core/theme/app_colors.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:client/services/user_service.dart';
import 'package:client/features/budget/pages/category_budget_page.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  Future<void> navigateToCategoryBudget(BuildContext context) async {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.userId : null;
    final UserService userService = UserService();
    try {
      int weddingId = await userService.getWeddingIdByUserId(userId!);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryBudgetPage(weddingId: weddingId),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get wedding ID: $e')),
        );
      }
    }
  }

  Widget _buildLanguagePicker(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'}
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final language = languages[index];
        bool isSelected = localeProvider.currentLocale.languageCode == language['code'];

        return GestureDetector(
          onTap: () {
            localeProvider.setLocale(language['code']!);
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('locale_code', language['code']!);
            });
          },
          child: Card(
            shape: isSelected
                ? RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.pink400, width: 2),
              borderRadius: BorderRadius.circular(10),
            )
                : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  language['flag']!,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  language['name']!,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
        backgroundColor: Colors.grey[100],
        actions: [
          ElevatedButton(
            onPressed: () {
              navigateToCategoryBudget(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPink, // bouton de couleur rose clair
            ),
            child: Text(
              'Gestion de Budget',
              style: TextStyle(color: AppColors.pink), // texte de couleur rose
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildLanguagePicker(context),
        ),
      ),
    );
  }
}
