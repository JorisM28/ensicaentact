import 'package:flutter/material.dart';
import '/Model/data/services/alumni_repository.dart';
import '/View/theme/colors.dart';
import '/service_locator.dart';
import '/Model/data/services/auth_service.dart';
import '/l10n/app_localizations.dart';

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
          SnackBar(content: Text(AppLocalizations.of(context)!.proposalSentSuccess)) 
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(traductions.drawerProposeEvent),
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
                decoration: InputDecoration(labelText: traductions.eventTitleLabel),
                validator: (v) => v!.isEmpty ? traductions.formRequired : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                items: [traductions.eventTypeMeeting, traductions.eventTypeConference, traductions.eventTypeAfterwork, traductions.eventTypeWebinar]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
                decoration: InputDecoration(labelText: traductions.typeLabel),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text("{traductions.dateLabel}${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
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
                decoration: InputDecoration(labelText: traductions.dialogLocationLabel),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(labelText: traductions.descriptionLabel),
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
                  child: Text(traductions.sendProposalBtn, style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}