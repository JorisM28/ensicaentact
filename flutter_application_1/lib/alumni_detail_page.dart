import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/profileBadge.dart';
import 'colors.dart';
import 'alumnis.dart';

class AlumniDetailPage extends StatelessWidget {
  final Alumnis alumni;
  final Map<String, dynamic> user;

  const AlumniDetailPage({
    super.key,
    required this.alumni,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = 40.0;
    double spacing = 10.0;


    int stageCount = alumni.stages.length;


    int divisor = stageCount > 0 ? stageCount : 1;
    if (divisor > 3) divisor = 3;


    double cardWidth = (screenWidth - horizontalPadding - (spacing * (divisor - 1))) / divisor;

    return Scaffold(
      appBar: AppBar(
        title: Text(alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            ProfileBadge(user: user),
            const SizedBox(height: 20),


            Text(
              alumni.nomComplet,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              "Promo ${alumni.promo}",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const Divider(height: 40),


            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: "Infos Pro",
                    items: [
                      _buildListTile(Icons.work, Colors.blue, "Poste", alumni.job),
                      _buildListTile(Icons.business, Colors.indigo, "Entreprise", alumni.entreprise),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoCard(
                    title: "Contact",
                    items: [
                      _buildListTile(Icons.location_on, Colors.red, "Ville", alumni.ville),
                      if (alumni.autor == 1 && alumni.decede == 0)
                        _buildListTile(Icons.email, Colors.green, "Email", alumni.email),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),


            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Text(
                  "Stages",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (alumni.stages.isEmpty)
              const Card(
                elevation: 1,
                child: ListTile(
                  title: Text("Aucun stage renseigné",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    children: alumni.stages.map((stage) {
                      return Container(
                        width: cardWidth,
                        margin: EdgeInsets.only(right: (stage == alumni.stages.last) ? 0 : spacing),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      stage.type == "E" ? Icons.apartment : Icons.school,
                                      color: AppColors.ensiCyan,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "${stage.annee} - ${stage.intitule}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                _buildStageField(stage.type == "U" ? "Université" : "Entreprise",stage.type == "E" ? Icons.apartment : Icons.school, Colors.green ,stage.entreprise),
                                _buildStageField("Lieu", Icons.location_on, Colors.red ,"${stage.ville}, ${stage.pays}", isItalic: true),
                                _buildStageField("Description",Icons.insert_drive_file, Colors.grey, stage.description),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }



  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, Color color, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: color, size: 18),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ensiCyan)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildStageField(String label, IconData icon, Color color, String value, {bool isItalic = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ensiCyan)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}