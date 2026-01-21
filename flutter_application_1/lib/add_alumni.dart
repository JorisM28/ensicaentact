import 'package:flutter/material.dart';
import 'database_service.dart';
import 'colors.dart';
class AddAlumniForm extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AddAlumniForm({super.key, this.onSuccess});

  @override
  State<AddAlumniForm> createState() => _AddAlumniFormState();
}

class _AddAlumniFormState extends State<AddAlumniForm> {
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _posteCtrl = TextEditingController();
  final _entrepriseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _stageCtrl = TextEditingController();
  final _promoCtrl = TextEditingController();
  final _filiereCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _ageCtrl.dispose();
    _posteCtrl.dispose();
    _entrepriseCtrl.dispose();
    _villeCtrl.dispose();
    _stageCtrl.dispose();
    _promoCtrl.dispose();
    _filiereCtrl.dispose();
    super.dispose();
  }

  Future<void> _soumettreFormulaire() async {
    if (_nomCtrl.text.isEmpty || _prenomCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nom et Prénom sont obligatoires")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await DatabaseService().ajouterEleve({
        "nom": _nomCtrl.text,
        "prenom": _prenomCtrl.text,
        "age": int.tryParse(_ageCtrl.text) ?? 22,
        "annee_promo": int.tryParse(_promoCtrl.text) ?? 2024,
        "filiere": _filiereCtrl.text,
        "sujet_stage": _stageCtrl.text,
        "poste": _posteCtrl.text,
        "entreprise": _entrepriseCtrl.text,
        "ville": _villeCtrl.text,
      });

      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout : $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Identité", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _nomCtrl, decoration: const InputDecoration(labelText: "Nom", border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: "Prénom", border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: _ageCtrl, decoration: const InputDecoration(labelText: "Âge", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            
            const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),
            
            const Text("Parcours ENSI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _promoCtrl, decoration: const InputDecoration(labelText: "Promo (ex: 2024)", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _filiereCtrl, decoration: const InputDecoration(labelText: "Filière", border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: _stageCtrl, decoration: const InputDecoration(labelText: "Sujet de stage (PFE)", border: OutlineInputBorder())),

            const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

            const Text("Poste Actuel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(controller: _posteCtrl, decoration: const InputDecoration(labelText: "Intitulé du poste", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _entrepriseCtrl, decoration: const InputDecoration(labelText: "Entreprise", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _villeCtrl, decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder())),

            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ensiCyan,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _isLoading ? null : _soumettreFormulaire,
              icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save, color: Colors.white),
              label: Text(_isLoading ? "Enregistrement..." : "Enregistrer l'Alumni", style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}