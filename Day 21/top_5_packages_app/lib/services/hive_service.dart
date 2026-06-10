import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String boxName = 'favorites';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Box get _box => Hive.box(boxName);

  Future<void> saveQuote(Map<String, dynamic> quote) async {
    await _box.add(quote);
  }

  List<Map<String, dynamic>> getQuotes() {
    return _box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> deleteQuote(int index) async {
    await _box.deleteAt(index);
  }

  bool quoteExists(String quoteText) {
    return _box.values.any(
      (item) => item['quote'] == quoteText,
    );
  }
}