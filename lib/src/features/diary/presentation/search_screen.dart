import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search title, content...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Filters',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              FilterChip(label: const Text('Mood'), onSelected: (v) {}),
              FilterChip(label: const Text('Date Range'), onSelected: (v) {}),
              FilterChip(label: const Text('Hashtag'), onSelected: (v) {}),
              FilterChip(label: const Text('Album'), onSelected: (v) {}),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('Search your audio journal memories'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
