import 'package:flutter/material.dart';
import '../../widget/company_card_widget.dart'; 
import '../../../ViewModel/employment_viewmodel.dart';
import '../../../l10n/app_localizations.dart'; 
import '../../widget/error_pages.dart';
import '/View/widget/company_card_widget.dart';
import '/View/widget/error_pages.dart';
import '/View/widget/custom_app_bar.dart';
import '/View/theme/colors.dart';
import '/ViewModel/employment_viewmodel.dart';


class CompaniesDirectoryPage extends StatefulWidget {
  const CompaniesDirectoryPage({super.key});

  @override
  State<CompaniesDirectoryPage> createState() => _CompaniesDirectoryPageState();
}

class _CompaniesDirectoryPageState extends State<CompaniesDirectoryPage> {
  late CareerViewModel viewModel;

  String _groupBy = 'Entreprise';
  Map<String,dynamic>? _selectedItem;

  @override
  void initState() {
    super.initState();
    viewModel = CareerViewModel();
    viewModel.loadCompanies();
    viewModel.addListener(() => setState(() {}));
  }

  List<Map<String, dynamic>> _getGroupedData() {
    if (_groupBy == 'Entreprise') return viewModel.allCompanies;

    Map<String, Map<String, dynamic>> cityGroups = {};
    for (var c in viewModel.allCompanies) {
      String city = c['ville'] ?? 'Inconnue';
      String country = c['pays'] ?? '';
      String key = '$city-$country';

      if (!cityGroups.containsKey(key)) {
        cityGroups[key] = {
          'nom_entreprise': city, 
          'ville': city,
          'pays': country,
          'nombre_alumni': 0,
          'latitude': c['latitude'],
          'longitude': c['longitude'],
          'entreprises_list': <String>{},
        };
      }
      cityGroups[key]!['nombre_alumni'] += (int.tryParse(c['nombre_alumni'].toString()) ?? 0);
      if (c['nom_entreprise'] != null && c['nom_entreprise'].toString().isNotEmpty) {
        cityGroups[key]!['entreprises_list'].add(c['nom_entreprise']);
      }
    }

    return cityGroups.values.map((group) {
      group['entreprises_list'] = group['entreprises_list'].toList();
      return group;
    }).toList();
  }

  List<Map<String, dynamic>> _getMapData() {
    if (_selectedItem == null) {
      return viewModel.allCompanies;
    }

    if (_groupBy == 'Entreprise') {
      return viewModel.allCompanies.where((c) =>
        c['nom_entreprise'] == _selectedItem!['nom_entreprise'] &&
        c['ville'] == _selectedItem!['ville']
      ).toList();
    }
    else {
      return viewModel.allCompanies.where((c) =>
        c['ville'] == _selectedItem!['ville'] &&
        c['pays'] == _selectedItem!['pays']
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    if (viewModel.hasAccessError) {
      return ErrorPage.forbidden(
        onRetry: () => viewModel.loadCompanies(),
      );
    }

    final displaydata = _getGroupedData();
    final mapData = _getMapData();

    return Scaffold(
      appBar: CustomAppBar(),
      body: viewModel.isLoadingCompanies
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterToggle(traductions), 
                Expanded(
                  child: isWideScreen
                      ? Row(
                          children: [
                            Expanded(flex: 2, child: _buildList(displaydata, traductions)), // Et ici
                            const VerticalDivider(width: 1),
                            Expanded(flex: 3, child: CompaniesMapWidget(companies: mapData, isFiltered: _selectedItem != null)) 
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(flex: 2, child: _buildList(displaydata, traductions)), // Et ici
                            const Divider(height: 1),
                            Expanded(flex: 3, child: CompaniesMapWidget(companies: mapData, isFiltered: _selectedItem != null))
                          ],
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterToggle(AppLocalizations traductions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SegmentedButton<String>(
        segments: [
          ButtonSegment(value: 'Entreprise', label: Text(traductions.companiesFilterCompany), icon: const Icon(Icons.business)),
          ButtonSegment(value: 'Ville', label: Text(traductions.companiesFilterCity), icon: const Icon(Icons.location_city)),
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

  Widget _buildList(List<Map<String, dynamic>> data, AppLocalizations traductions) {
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
                    Expanded(child: Text(item['nom_entreprise'] ?? traductions.unknownCompany, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ensiCyan))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.ensiCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text("${item['nombre_alumni'] ?? 0} ${traductions.alumniLabel}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
