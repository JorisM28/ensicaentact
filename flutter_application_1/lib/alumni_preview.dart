import 'package:flutter/material.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'alumni_detail_page.dart';

class AlumniPreview extends StatelessWidget {
  final Alumnis alumni;
  final Map<String, dynamic> user;
  const AlumniPreview({super.key, required this.alumni, required this.user});
  bool get estAdmin => user['role'] == 'admin';


  void _ouvrirPageComplete(BuildContext context) {
    if (estAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>AlumniDetailPage(alumni: alumni, user: user),
          ),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlumniDetailPage(alumni: alumni, user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _ouvrirPageComplete(context),
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
                radius: 70,
                backgroundColor: AppColors.ensiCyan,
                child: Text(
                  alumni.prenom.isNotEmpty ? alumni.prenom[0] : "?",
                  style: const TextStyle(fontSize: 60, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              alumni.nomComplet,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (alumni.job.isNotEmpty || alumni.entreprise.isNotEmpty)
            Text(
              "${alumni.job} ${alumni.entreprise.isEmpty || alumni.job.isEmpty ? "" : "chez"} ${alumni.entreprise}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (alumni.tel.isNotEmpty) 
                  _infoBulle(Icons.calendar_month_outlined, alumni.promo.toString(), Colors.orangeAccent),
                if (alumni.email.isNotEmpty) 
                  _infoBulle(Icons.location_on, alumni.ville, Colors.red),
                if  (alumni.filiere.isNotEmpty) 
                  _infoBulle(Icons.school, alumni.filiere.toString(), Colors.green),
                if (alumni.majeure.isNotEmpty) 
                  _infoBulle(Icons.auto_awesome, alumni.majeure, Colors.cyan),
              ],
            ),
            const SizedBox(height: 40),

            const Divider(height: 1),

            const SizedBox(height: 40),

            if (alumni.stages.isNotEmpty)...[
              Text(
                "Stages :",
                style: TextStyle(fontSize: 18,   fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  for (var stage in alumni.stages)
                    Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                      
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 211, 211, 211),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3), 
                          ),
                        ],
                      ),
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (stage.entreprise.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.calendar_today, stage.annee, Colors.purple)),
                          if (stage.entreprise.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.public, stage.pays, Colors.lightBlue)),
                          if (stage.entreprise.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.location_city, stage.ville, Colors.teal)),
                          if (stage.entreprise.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.subject, stage.intitule, Colors.pink)),
                        ],
                      ),
                    ),
                ],
              ),
            ],

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ensiCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () => _ouvrirPageComplete(context),
              icon: const Icon(Icons.visibility),
              label: const Text("Voir la fiche complète"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoBulle(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}