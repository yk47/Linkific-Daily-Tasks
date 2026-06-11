import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NetworkErrorScreen extends StatefulWidget {
  const NetworkErrorScreen({super.key});

  @override
  State<NetworkErrorScreen> createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends State<NetworkErrorScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String result = "";

  Future<void> callApi(Future<dynamic> Function() apiCall) async {
    setState(() {
      isLoading = true;
      result = "";
    });

    try {
      final response = await apiCall();

      setState(() {
        result = response.toString().substring(
              0,
              response.toString().length > 1000
                  ? 1000
                  : response.toString().length,
            );
      });
    } catch (e) {
      setState(() {
        result = "ERROR:\n$e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Debug Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Use this screen to debug API calls using Dio.\n"
                  "Check Flutter DevTools → Network tab.",
                ),
              ),
            ),

            const SizedBox(height: 20),

            buildButton(
              title: "Call Success API",
              color: Colors.green,
              onTap: () => callApi(apiService.fetchPosts),
            ),

            const SizedBox(height: 10),

            buildButton(
              title: "Call Broken API",
              color: Colors.red,
              onTap: () => callApi(apiService.fetchBrokenApi),
            ),

            const SizedBox(height: 10),

            buildButton(
              title: "Call Slow API",
              color: Colors.orange,
              onTap: () => callApi(apiService.fetchSlowApi),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      result.isEmpty
                          ? "No data yet"
                          : result,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}