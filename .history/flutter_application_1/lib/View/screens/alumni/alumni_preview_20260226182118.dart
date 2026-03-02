import 'package:flutter/material.dart';
import '../../../Model/core/theme/colors.dart';
import '../../../Model/alumnis.dart';
import '../../../ViewModel/alumni/alumni_preview_viewmodel.dart';

class AlumniPreview extends StatelessWidget {
  final AlumniPreviewViewModel viewModel;

  AlumniPreview({super.key, required Alumnis alumni})
      : viewModel = AlumniPreviewViewModel(alumni: alumni);

  @override
  Widget build(BuildContext context) {
    final alumni = viewModel.alumni;

    return GestureDetector(
      onDoubleTap: () => viewModel.ouvrirPageComplete(context),
      child: Container(
        padding: const EdgeInsets.all(30),
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: alumni.email,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.ensiCyan,
                child: Text(
                  alumni.firstname.isNotEmpty ? alumni.firstname[0] : "?",
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              alumni.wholeName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (viewModel.jobAndCompany.isNotEmpty)
              Text(
                viewModel.jobAndCompany,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40),
            _buildQuickInfoGrid(alumni),
            const SizedBox(height: 40),
            const Divider(height: 1),
            const SizedBox(height: 40),
            if (alumni.internships.isNotEmpty) _buildInternshipsList(alumni),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ensiCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () => viewModel.ouvrirPageComplete(context),
              icon: const Icon(Icons.visibility),
              label: const Text("Voir la fiche complète"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoGrid(Alumnis alumni) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (alumni.promotion != 0)
          _infoBulle(Icons.calendar_month_outlined, alumni.promotion.toString(), Colors.orangeAccent),
        if (alumni.city.isNotEmpty)
          _infoBulle(Icons.location_on, alumni.city, Colors.red),
        if (alumni.sector.isNotEmpty)
          _infoBulle(Icons.school, alumni.sector, Colors.green),
        if (alumni.specialisation.isNotEmpty)
          _infoBulle(Icons.auto_awesome, alumni.specialisation, Colors.cyan),
      ],
    );
  }

  Widget _buildInternshipsList(Alumnis alumni) {
    return Column(
      children: [
        const Text(
          "Stages :",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ...alumni.internships.map((stage) => Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 235, 235),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _infoBulle(Icons.calendar_today, stage.year, Colors.purple)),
              Expanded(child: _infoBulle(Icons.public, stage.country, Colors.lightBlue)),
              Expanded(child: _infoBulle(Icons.location_city, stage.city, Colors.teal)),
              Expanded(child: _infoBulle(Icons.subject, stage.entitled, Colors.pink)),
            ],
          ),
        )),
      ],
    );
  }

  Widget _infoBulle(IconData icon, String text, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}