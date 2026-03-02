import 'package:flutter/material.dart';
import '/Model/data/services/alumni_repository.dart';
import '/View/theme/colors.dart';
import '/service_locator.dart';
import '/Model/data/services/auth_service.dart';

class ProposeEventPage extends StatefulWidget {
  const ProposeEventPage({super.key});

  @override
  State<ProposeEventPage> createState() => _ProposeEventPageState();
}

class _ProposeEventPageState extends State<ProposeEventPage> {
  final _formKey = GlobalKey<FormState>();
    final currentUser = sl<AuthService>().currentUser;
  final _titleControlelr = TextEditingController();
  final _placecontroller = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Rencontre';
  DateTime _selectedDate = DateTime.now();

  void _submitPropose() async {
if (_formKey.currentState!.validate()) {
    Map<String, dynamic> proposition = {
      "titre": _titleControlelr.text,
      "type": _selectedType,
      "date_event": _selectedDate.toString(),
      "lieu": _placecontroller.text,
      "description": _descriptionController.text,
      "id_auteur": currentUser?.id,
      "nom_auteur": currentUser?.lastname, 
      "prenom_auteur": currentUser?.firstname,
      "email_auteur": currentUser?.email,
    };

  
      bool success = await sl<AlumniRepository>().requestEvent(proposition);

      if (success && mounted) {
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
                controller: _titleControlelr,
                decoration: const InputDecoration(labelText: "Titre de l'évènement"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                items: ["Rencontre", "Conférence", "Afterwork", "Webinaire"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
                decoration: const InputDecoration(labelText: "Type"),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text("Date : ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              TextFormField(
                controller: _placecontroller,
                decoration: const InputDecoration(labelText: "Lieu"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
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
                  onPressed: _submitPropose,
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