import 'package:flutter/material.dart';
import '../database_service.dart'; 
import '../page_évènements.dart'; 

class EventWidget extends StatelessWidget {
  final Map<String, dynamic> user; 

  const EventWidget({super.key, required this.user});

  
  Map<String, String> _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return {"day": "??", "month": "??"};
    try {
      DateTime dt = DateTime.parse(dateString);
      List<String> months = ["JAN", "FÉV", "MAR", "AVR", "MAI", "JUIN", "JUIL", "AOÛT", "SEPT", "OCT", "NOV", "DÉC"];
      return {
        "day": dt.day.toString().padLeft(2, '0'),
        "month": months[dt.month - 1]
      };
    } catch (e) {
      return {"day": "??", "month": "??"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "ÉVÈNEMENTS",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 1.0, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseService().getEvenements(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Aucun événement à venir.");
              }

              final events = snapshot.data!.take(5).toList(); 

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(events[index], context);
                },
              );
            },
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageEvenements(user: user)),
                );
              },
              child: const Text(
                "Voir tous les évènements",
                style: TextStyle(color: Color(0xFFE30613), fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, BuildContext context) {
    final dateMap = _formatDate(event['date_event']); 

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsEvenementPage(item: event),
              ),
            );
          },
          child: SizedBox(
            height: 100, 
            child: Row(
              children: [
                Ink(
                  width: 100, 
                  color: const Color(0xFFF2F2F2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateMap['day']!, 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE30613))
                      ),
                      Text(
                        dateMap['month']!, 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event['titre'] ?? "Événement", 
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${event['type'] ?? ''} • ${event['lieu'] ?? ''}", 
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}