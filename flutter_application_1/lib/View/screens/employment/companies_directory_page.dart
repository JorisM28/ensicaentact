import 'package:flutter/material.dart';
import '../../../Model/core/theme/colors.dart';
import '../../widget/carte_entreprise_widget.dart';
import '../../../ViewModel/employment_viewmodel.dart';

import '/View/widget/custom_app_bar.dart';
class CompaniesDirectoryPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const CompaniesDirectoryPage({super.key, required this.user});

  @override
  State<CompaniesDirectoryPage> createState() => _CompaniesDirectoryPageState();
}

class _CompaniesDirectoryPageState extends State<CompaniesDirectoryPage> {
  late CareerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CareerViewModel(user: widget.user);
    viewModel.loadCompanies();
    viewModel.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
        appBar: CustomAppBar(),
      body: viewModel.isLoadingCompanies
          ? const Center(child: CircularProgressIndicator())
          : isWideScreen
          ? Row(children: [Expanded(flex: 2, child: _buildList()), const VerticalDivider(width: 1), Expanded(flex: 3, child: CarteEntrepriseWidget(companies: viewModel.allCompanies))])
          : Column(children: [Expanded(flex: 2, child: _buildList()), const Divider(height: 1), Expanded(flex: 3, child: CarteEntrepriseWidget(companies: viewModel.allCompanies))]),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.allCompanies.length,
      separatorBuilder: (_, __) => const Divider(height: 30),
      itemBuilder: (context, index) {
        final item = viewModel.allCompanies[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: AppColors.ensiCyan),
                const SizedBox(width: 10),
                Expanded(child: Text(item['nom_entreprise'] ?? "Inconnu", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ensiCyan))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.ensiCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text("${item['nombre_alumni'] ?? 0} alumni", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 34),
              child: Text("${item['ville'] ?? ''}, ${item['pays'] ?? ''}"),
            ),
          ],
        );
      },
    );
  }
}