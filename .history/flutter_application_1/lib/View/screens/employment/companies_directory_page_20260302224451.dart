import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/View/widget/custom_app_bar.dart';
import '/View/theme/colors.dart';
import '/ViewModel/employment_viewmodel.dart';
import '/View/widget/company_card_widget.dart';

class CompaniesDirectoryPage extends StatefulWidget {
  const CompaniesDirectoryPage({super.key});

  @override
  State<CompaniesDirectoryPage> createState() => _CompaniesDirectoryPageState();
}

class _CompaniesDirectoryPageState extends State<CompaniesDirectoryPage> {
  late CareerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CareerViewModel();
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
          : Column(
              children: [
                _buildFilterToggle(),
                Expanded(
                  child: isWideScreen
                      ? Row(
                          children: [
                            Expanded(flex: 2, child: _buildList(displaydata)),
                            const VerticalDivider(width: 1),
                            Expanded(flex: 3, child: CompaniesMapWidget(companies: mapData, isFiltered: _selectedItem !=null))
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(flex: 2, child: _buildList(displaydata)),
                            const Divider(height: 1),
                            Expanded(flex: 3, child: CompaniesMapWidget(companies: mapData, isFiltered: _selectedItem !=null))
                          ],
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'Entreprise', label: Text('Par Entreprise'), icon: Icon(Icons.business)),
          ButtonSegment(value: 'Ville', label: Text('Par Ville'), icon: Icon(Icons.location_city)),
        ],
        selected: {_groupBy},
        onSelectionChanged: (Set<String> newSelection) {
          setState(() {
            _groupBy = newSelection.first;
            _selectedItem = null;
          });
        },
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.ensiCyan.withOpacity(0.2),
          selectedForegroundColor: AppColors.ensiCyan,
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = data[index];
        final isCityMode = _groupBy == 'Ville';

        bool isSelected = false;
        if (_selectedItem != null) {
          if (isCityMode) {
            isSelected = _selectedItem!['ville'] == item['ville'] &&
                         _selectedItem!['pays'] == item['pays'];
          } else {
            isSelected = _selectedItem!['nom_entreprise'] == item['nom_entreprise'] &&
                         _selectedItem!['ville'] == item['ville'];
          }
        }

        return InkWell(
          onTap: () {
            setState(() {
              _selectedItem = isSelected ? null : item;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.ensiCyan.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.ensiCyan : Colors.grey.shade300,
                width: 1
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(isCityMode ? Icons.location_city : Icons.business, color: AppColors.ensiCyan),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${item['ville'] ?? ''}, ${item['pays'] ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (isCityMode && item['entreprises_list'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text((item['entreprises_list'] as List).join(' • '), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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