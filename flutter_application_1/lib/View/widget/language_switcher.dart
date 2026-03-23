import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/View/theme/colors.dart';
import '/main.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {

    final localeProvider = Provider.of<LocaleProvider>(context);
    final isFrench = localeProvider.locale.languageCode == 'fr';

    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangButton(context, 'FR', 'fr', isFrench),
          _buildLangButton(context, 'EN', 'en', !isFrench),
        ],
      ),
    );
  }

  Widget _buildLangButton(BuildContext context, String title, String langCode, bool isSelected) {
    return InkWell(
      onTap: () {

        Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(langCode));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.ensiCyan : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}