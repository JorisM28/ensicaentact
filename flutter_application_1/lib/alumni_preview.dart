import 'package:flutter/material.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'alumni_detail_page.dart';

class AlumniPreview extends StatelessWidget {
  final Alumnis alumni;
  final Map<String, dynamic> user;
  const AlumniPreview({super.key, required this.alumni, required this.user});
  bool get isAdmin => user['role'] == 'admin';


  void _ouvrirPageComplete(BuildContext context) {
    if (isAdmin) {
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
                  alumni.firstname.isNotEmpty ? alumni.firstname[0] : "?",
                  style: const TextStyle(fontSize: 60, color: Colors.white),
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
            if (alumni.job.isNotEmpty || alumni.company.isNotEmpty)
            Text(
              "${alumni.job} ${alumni.company.isEmpty || alumni.job.isEmpty ? "" : "chez"} ${alumni.company}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (alumni.phone.isNotEmpty) 
                  _infoBulle(Icons.calendar_month_outlined, alumni.promotion.toString(), Colors.orangeAccent),
                if (alumni.email.isNotEmpty) 
                  _infoBulle(Icons.location_on, alumni.city, Colors.red),
                if  (alumni.sector.isNotEmpty) 
                  _infoBulle(Icons.school, alumni.sector.toString(), Colors.green),
                if (alumni.specialisation.isNotEmpty) 
                  _infoBulle(Icons.auto_awesome, alumni.specialisation, Colors.cyan),
              ],
            ),
            const SizedBox(height: 40),

            const Divider(height: 1),

            const SizedBox(height: 40),

            if (alumni.internships.isNotEmpty)...[
              Text(
                "Stages :",
                style: TextStyle(fontSize: 18,   fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  for (var stage in alumni.internships)
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
                          if (stage.company.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.calendar_today, stage.year, Colors.purple)),
                          if (stage.company.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.public, stage.country, Colors.lightBlue)),
                          if (stage.company.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.location_city, stage.city, Colors.teal)),
                          if (stage.company.isNotEmpty) 
                            Expanded(child: _infoBulle(Icons.subject, stage.entitled, Colors.pink)),
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