import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;

  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: Text(country.name),
        backgroundColor: const Color(0xFF0A0E1A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                country.flag,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            _infoCard("Country", country.name),
            _infoCard("Capital", country.capital),
            _infoCard("Region", country.region),

            _infoCard("Population", _formatPopulation(country.population)),

            _infoCard("Currency", country.currency),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      color: const Color(0xFF131828),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white70)),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatPopulation(int n) {
    if (n >= 1000000000) {
      return '${(n / 1000000000).toStringAsFixed(1)} Billion';
    }
    if (n >= 1000000) {
      return '${(n / 1000000).toStringAsFixed(1)} Million';
    }
    return n.toString();
  }
}
