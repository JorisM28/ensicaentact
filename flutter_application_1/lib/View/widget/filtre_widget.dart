import 'package:flutter/material.dart';
import '/View/theme/colors.dart';
import '/l10n/app_localizations.dart';

class ZoneFiltres extends StatelessWidget {
  final List<String> promotionAvailable;
  final List<String> sectorAvailable;
  final List<String> internshipCountryAvailable;

  final Set<String> selectedPromotion;
  final Set<String> sectorFilterSelected;
  final Set<String> internshipCountryFilterSelected;

  final Function(String, bool) onPromoChanged;
  final Function(String, bool) onSectorChanged;
  final Function(String, bool) onInternshipCountryChanged;

  const ZoneFiltres({
    super.key,
    required this.promotionAvailable,
    required this.onPromoChanged,
    required this.selectedPromotion,

    required this.sectorAvailable,
    required this.sectorFilterSelected,
    required this.onSectorChanged,

    required this.internshipCountryAvailable,
    required this.internshipCountryFilterSelected,
    required this.onInternshipCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!; 
    if (promotionAvailable.isEmpty && sectorAvailable.isEmpty && internshipCountryAvailable.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (promotionAvailable.isNotEmpty) ...[
          Text(traductions.filterPromotions, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: promotionAvailable.map((promo) {
              final estCoche = selectedPromotion.contains(promo);
              return FilterChip(
                label: Text(promo),
                selected: estCoche,
                onSelected: (bool selected) {
                  onPromoChanged(promo, selected);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
        ],

        if (sectorAvailable.isNotEmpty) ...[
          Text(traductions.filterPromotions, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: sectorAvailable.map((filiere) {
              final estCoche = sectorFilterSelected.contains(filiere);
              return FilterChip(
                label: Text(filiere),
                selected: estCoche,
                checkmarkColor: Colors.white,
                selectedColor: AppColors.ensiCyan,
                labelStyle: TextStyle(
                  color: estCoche ? Colors.white : Colors.black
                ),
                onSelected: (bool selected) {
                  onSectorChanged(filiere, selected);
                },
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 15),

        if (internshipCountryAvailable.isNotEmpty) ...[
          Text(traductions.filterInternshipCountry, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: internshipCountryAvailable.map((pays) {
              final estCoche = internshipCountryFilterSelected.contains(pays);
              
              return FilterChip(
                label: Text(pays),
                selected: estCoche,
                checkmarkColor: Colors.white,
                selectedColor: AppColors.ensiCyan,
                labelStyle: TextStyle(
                  color: estCoche ? Colors.white : Colors.black
                ),
                onSelected: (bool selected) {
                  onInternshipCountryChanged(pays, selected);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}