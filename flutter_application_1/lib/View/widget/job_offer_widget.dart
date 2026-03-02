import 'package:flutter/material.dart';
import '../../Model/user_model.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';
import '/View/screens/employment/job_page.dart';

class JobOfferWidget extends StatelessWidget {
  final User user;

  const JobOfferWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: const Color(0xFFE6E6E6),
      child: Column(
        children: [
          const Text(
            "OFFRES D'EMPLOI & STAGES",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: sl<AlumniRepository>().getOffers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Aucune offre disponible.");
              }

              final offres = snapshot.data!.take(4).toList();

              return Column(
                children: offres.map((job) => _buildJobCard(job)).toList(),
              );
            },
          ),

          const SizedBox(height: 30),

          OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => JobPage(user: user)));
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE30613)),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            ),
            child: const Text(
              "Voir toutes les offres",
              style: TextStyle(color: Color(0xFFE30613), fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {

    final String type = (job['type'] ?? 'CDI').toString();
    final bool isStage = type.toLowerCase() == 'stage';
    final Color badgeColor = isStage ? Colors.orange[800]! : Colors.blue[800]!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['titre'] ?? "Poste",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${job['entreprise'] ?? ''} - ${job['ville'] ?? ''}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              type.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}