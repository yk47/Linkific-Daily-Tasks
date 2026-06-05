import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/country.dart';
import '../screens/country_details_screen.dart';

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CountryDetailsScreen(country: country));
      },
      child: Card(
        child: ListTile(
          leading: Image.network(country.flag, width: 50),
          title: Text(country.name),
          subtitle: Text(country.capital),
        ),
      ),
    );
  }
}
