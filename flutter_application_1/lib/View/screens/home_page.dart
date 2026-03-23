import 'package:flutter/material.dart';
import '/View/theme/colors.dart';
import '/View/widget/actuality_widget.dart';
import '/View/widget/event_widget.dart';
import '/View/widget/job_offer_widget.dart';
import '/View/widget/key_figures_widget.dart';
import '/service_locator.dart';
import '/l10n/app_localizations.dart'; 
import '/Model/data/services/auth_service.dart';
import '/View/widget/base_layout.dart';
import '/ViewModel/home/home_viewmodel.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  final Color contentColor = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    final traductions = AppLocalizations.of(context)!;
    final String role = currentUser?.role ?? 'guest';
    final bool isConnected = sl<AuthService>().isLoggedIn;

  return BaseLayout(
    body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20,),

            KeyFiguresWidget(isAdmin: role == "admin"),

            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: isDesktop
                    ? _buildDesktopLayout(context)
                    : _buildMobileLayout(context, traductions)
            ),

            const Divider(height: 1, thickness: 1),

            if (!isConnected) JobOfferWidget(),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ActualityWidget(
                onAddPress: () => showAddNewsDialog(context, traductions),
              ),
            ),

            const VerticalDivider(width: 60, thickness: 1, color: Colors.white),

            Expanded(
              flex: 1,
              child: EventWidget(
                onAddPress: () => showAddEventDialog(context, traductions),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, traductions) {
    return Column(
      children: [
        Container(
          height: 520,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: ActualityWidget(
            onAddPress: () => showAddNewsDialog(context, traductions),
          ),
        ),

        const SizedBox(height: 20),

        Container(
          height: 520,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: EventWidget(
              onAddPress: () => showAddEventDialog(context, traductions)
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.ensiCyan,
      width: double.infinity,
      child: const Text("©2026 ENSICAEN Alumni",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center),
    );
  }


}