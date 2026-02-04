import 'package:flutter/material.dart';
import '../colors.dart';
import '../database_service.dart';

class PageProposerEvenement extends StatefulWidget {
  final Map<String, dynamic> user;
  const PageProposerEvenement({super.key, required this.user});

  @override
  State<PageProposerEvenement> createState() => _PageProposerEvenementState();
}

class _PageProposerEvenementState extends State<PageProposerEvenement> {
  final _formKey = GlobalKey<FormState>();
  
  final _titreCtrl = TextEditingController();
  final _lieuCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _typeSelectionne = 'Rencontre';
  DateTime _dateSelectionnee = DateTime.now();

  void _soumettreProposition() async {
if (_formKey.currentState!.validate()) {
    Map<String, dynamic> proposition = {
      "titre": _titreCtrl.text,
      "type": _typeSelectionne,
      "date_event": _dateSelectionnee.toString(),
      "lieu": _lieuCtrl.text,
      "description": _descCtrl.text,
      "id_auteur": widget.user['id_user'],
      "nom_auteur": widget.user['nom'], 
      "prenom_auteur": widget.user['prenom'],
      "email_auteur": widget.user['email'],
    };

  
      bool succes = await DatabaseService().proposerEvenement(proposition);

      if (succes && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Proposition envoyée à l'administrateur !"))
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proposer un évènement"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreCtrl,
                decoration: const InputDecoration(labelText: "Titre de l'évènement"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _typeSelectionne,
                items: ["Rencontre", "Conférence", "Afterwork", "Webinaire"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _typeSelectionne = v!),
                decoration: const InputDecoration(labelText: "Type"),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text("Date : ${_dateSelectionnee.day}/${_dateSelectionnee.month}/${_dateSelectionnee.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dateSelectionnee,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _dateSelectionnee = picked);
                },
              ),
              TextFormField(
                controller: _lieuCtrl,
                decoration: const InputDecoration(labelText: "Lieu"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Description détaillée"),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ensiCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15)
                  ),
                  onPressed: _soumettreProposition,
                  child: const Text("Envoyer la proposition", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}