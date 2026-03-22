import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/Model/data/services/alumni_repository.dart';
import '/Model/data/services/auth_service.dart';
import '/View/screens/home_page.dart';
import '/l10n/app_localizations.dart';
import '/service_locator.dart';

void showAddNewsDialog(BuildContext context, AppLocalizations traductions) {
  final currentUser = sl<AuthService>().currentUser;
  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(traductions.dialogLoginRequiredNews)),
    );
    return;
  }

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imgCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(traductions.dialogNewNews),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleCtrl, decoration: InputDecoration(labelText: traductions.dialogTitleLabel)),
          TextField(controller: descCtrl, decoration: InputDecoration(labelText: traductions.descriptionField), maxLines: 3),
          TextField(controller: imgCtrl, decoration: InputDecoration(labelText: traductions.dialogImageUrlLabel)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
        ElevatedButton(
          onPressed: () async {
            if (titleCtrl.text.isEmpty) return;

            await sl<AlumniRepository>().addNews({
              "titre": titleCtrl.text,
              "description": descCtrl.text,
              "image": imgCtrl.text,
              "auteur_id": currentUser.role,
            });

            Navigator.pop(ctx);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomePage()));
          },
          child: Text(traductions.publish),
        ),
      ],
    ),
  );
}

void showAddEventDialog(BuildContext context, AppLocalizations traductions) {
  final titreCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final lieuCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final currentUser = sl<AuthService>().currentUser;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(traductions.dialogNewEvent),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titreCtrl, decoration: InputDecoration(labelText: traductions.dialogTitleLabel)),
            TextField(controller: descCtrl, decoration: InputDecoration(labelText: traductions.descriptionField), maxLines: 3),
            TextField(controller: lieuCtrl, decoration: InputDecoration(labelText: traductions.dialogLocationLabel)),
            TextField(
              controller: dateCtrl,
              decoration: InputDecoration(labelText: traductions.dialogDateTimeLabel),
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());

                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  locale: Locale(Localizations.localeOf(context).languageCode),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 0, minute: 0),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    String formattedDate = pickedDate.toIso8601String().split('T')[0];
                    String formattedHour = pickedTime.hour.toString().padLeft(2, '0');
                    String formattedMinute = pickedTime.minute.toString().padLeft(2, '0');

                    dateCtrl.text = "$formattedDate $formattedHour:$formattedMinute:00";
                  }
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
        ElevatedButton(
          onPressed: () async {
            if (titreCtrl.text.isEmpty) return;

            await sl<AlumniRepository>().addEvent({
              "titre": titreCtrl.text,
              "description": descCtrl.text,
              "lieu": lieuCtrl.text,
              "date_event": dateCtrl.text,
              "auteur_id": currentUser?.id,
              "valide": 1
            });

            Navigator.pop(ctx);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomePage()));
          },
          child: Text(traductions.publish),
        ),
      ],
    ),
  );
}
