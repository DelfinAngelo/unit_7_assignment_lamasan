
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl = 'https://narutodb.xyz/api/character';

  Future<List<dynamic>> fetchCharacters() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      return data['characters']; 
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Naruto Characters"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                final controller = ExpandedTileController();

                return ExpandedTile(
                  controller: controller,
                  title: Text(character['name'] ?? 'No Name'),
                  leading: character['image'] != null
                      ? Image.network(
                          character['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(character['description'] ?? 'No description available'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
