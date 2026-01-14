Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Trouver un Alumni :",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                FilterChipExample(),
              ],
            ),