import 'package:flutter/material.dart';
import '/ViewModel/widget/event_widget_viewmodel.dart';
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
  final EventWidgetViewModel _viewModel = sl<EventWidgetViewModel>();

  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedType;
  DateTime _selectedDate = DateTime.now();

  Future<void> _submitPropose() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = sl<AuthService>().currentUser;

      Map<String, dynamic> proposition = {
        "titre": _titleController.text,
        "type": _selectedType,
        "date_event": _selectedDate.toString(),
        "lieu": _placeController.text,
        "description": _descriptionController.text,
        "id_auteur": currentUser?.id,
        "nom_auteur": currentUser?.lastname,
        "prenom_auteur": currentUser?.firstname,
        "email_auteur": currentUser?.email,
      };

      bool success = await _viewModel.proposeEvent(proposition);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.proposalSentSuccess))
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final eventTypes = [
      traductions.eventTypeMeeting,
      traductions.eventTypeConference,
      traductions.eventTypeAfterwork,
      traductions.eventTypeWebinar
    ];
    _selectedType ??= eventTypes.first;
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
                controller: _titleController,
                decoration: InputDecoration(labelText: traductions.eventTitleLabel),
                validator: (v) => v!.isEmpty ? traductions.formRequired : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: eventTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedType = v);
                  }
                },
                decoration: InputDecoration(labelText: traductions.typeLabel),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text("${traductions.dateLabel} ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
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
                controller: _placeController,
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
                child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ensiCyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(15)
                        ),
                        onPressed: _viewModel.isLoading ? null : _submitPropose,
                        child: _viewModel.isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(traductions.sendProposalBtn, style: const TextStyle(fontSize: 16)),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}