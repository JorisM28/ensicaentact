import 'package:flutter/material.dart';
import 'colors.dart';

class ZoneFiltres extends StatelessWidget {
  final List<String> promosDisponibles;
  final List<String> filieresDisponibles;
  final List<String> paysStageDisponibles;

  final Set<String> promosSelectionnees;
  final Set<String> filieresSelectionnees;
  final Set<String> paysStageSelectionnees;

  final Function(String, bool) onPromoChanged;
  final Function(String, bool) onFiliereChanged;
  final Function(String, bool) onPaysStageChanged;

  const ZoneFiltres({
    super.key,
    required this.promosDisponibles,
    required this.onPromoChanged,
    required this.promosSelectionnees,

    required this.filieresDisponibles,
    required this.filieresSelectionnees,
    required this.onFiliereChanged,

    required this.paysStageDisponibles,
    required this.paysStageSelectionnees,
    required this.onPaysStageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (promosDisponibles.isEmpty && filieresDisponibles.isEmpty && paysStageDisponibles.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (promosDisponibles.isNotEmpty) ...[
          const Text("Promotions :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: promosDisponibles.map((promo) {
              final estCoche = promosSelectionnees.contains(promo);
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

        if (filieresDisponibles.isNotEmpty) ...[
          const Text("Filières :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: filieresDisponibles.map((filiere) {
              final estCoche = filieresSelectionnees.contains(filiere);
              return FilterChip(
                label: Text(filiere),
                selected: estCoche,
                checkmarkColor: Colors.white,
                selectedColor: AppColors.ensiCyan,
                labelStyle: TextStyle(
                  color: estCoche ? Colors.white : Colors.black
                ),
                onSelected: (bool selected) {
                  // On prévient le parent !
                  onFiliereChanged(filiere, selected);
                },
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 15),

        if (paysStageDisponibles.isNotEmpty) ...[
          const Text("Pays Stage :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: paysStageDisponibles.map((pays) {
              final estCoche = paysStageSelectionnees.contains(pays);
              
              return FilterChip(
                label: Text(pays),
                selected: estCoche,
                checkmarkColor: Colors.white,
                selectedColor: AppColors.ensiCyan,
                labelStyle: TextStyle(
                  color: estCoche ? Colors.white : Colors.black
                ),
                onSelected: (bool selected) {
                  // CORRECTION : Appelle le callback pour le pays
                  onPaysStageChanged(pays, selected);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}