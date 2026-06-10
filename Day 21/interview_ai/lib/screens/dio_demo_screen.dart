import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:top_5_packages_app/core/theme/app_theme.dart';
import 'package:top_5_packages_app/services/dio_service.dart';

/// Demonstrates Dio HTTP client features:
/// - GET/POST requests
/// - Interceptors (logging, retry)
/// - Request cancellation
class DioDemoScreen extends StatefulWidget {
  const DioDemoScreen({super.key});

  @override
  State<DioDemoScreen> createState() => _DioDemoScreenState();
}

class _DioDemoScreenState extends State<DioDemoScreen> {
  late final DioService _dioService;
  final List<Map<String, dynamic>> _posts = [];
  CancelToken? _cancelToken;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dioService = Get.find<DioService>();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _posts.clear();
    });

    _cancelToken = CancelToken();
    final response = await _dioService.get(
      '/posts',
      queryParameters: {'_limit': 10},
      cancelToken: _cancelToken,
    );

    if (response != null && mounted) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      setState(() {
        _posts.addAll(data);
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        _error = 'Failed to fetch posts';
        _isLoading = false;
      });
    }
  }

  void _cancelRequest() {
    _cancelToken?.cancel('User cancelled the request');
    setState(() => _isLoading = false);
  }

  Future<void> _createPost() async {
    setState(() => _isLoading = true);
    final response = await _dioService.post(
      '/posts',
      data: {
        'title': 'Dio Demo Post',
        'body': 'Created using Dio HTTP client with interceptors!',
        'userId': 1,
      },
    );

    if (response != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created! ID: ${response.data['id']}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Screen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 15, color: AppColors.textPrimary),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Dio HTTP Client'),
      ),
      body: Column(
        children: [
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchPosts,
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('GET Posts'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _createPost,
                    icon: const Icon(Icons.upload_rounded, size: 18),
                    label: const Text('POST'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mint,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (_isLoading)
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _cancelRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
              ],
            ),
          ),
          // Interceptor log
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INTERCEPTOR LOG',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_dioService.logs.isEmpty)
                      const Text(
                        'No requests yet...',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      )
                    else
                      ..._dioService.logs.take(3).map((log) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              log,
                              style: TextStyle(
                                color: log.contains('[ERROR]')
                                    ? AppColors.error
                                    : log.contains('[RESPONSE]')
                                        ? AppColors.success
                                        : AppColors.textSecondary,
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          )),
                  ],
                )),
          ),
          const SizedBox(height: 16),
          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.error, fontSize: 14),
              ),
            ),
          // Results
          Expanded(
            child: _posts.isEmpty
                ? const Center(
                    child: Text(
                      'Tap "GET Posts" to fetch data\nusing Dio HTTP client',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'] ?? '',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (post['body'] ?? '').toString().substring(0, 80),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}