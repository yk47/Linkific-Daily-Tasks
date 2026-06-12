class Country {
  final String name;
  final String capital;
  final String region;
  final String flag;
  final int population;
  final String currency;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.flag,
    required this.population,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String currency = "";

    if (json["currencies"] != null) {
      currency = (json["currencies"] as Map).values.first["name"] ?? "";
    }

    return Country(
      name: json["name"]["common"] ?? "",
      capital: json["capital"] != null ? json["capital"][0] : "",
      region: json["region"] ?? "",
      flag: json["flags"]["png"] ?? "",
      population: json["population"] ?? 0,
      currency: currency,
    );
  }
}
