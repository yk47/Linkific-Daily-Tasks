import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool _isConnected = true.obs;

  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(result);
  }

  void _updateConnectivityStatus(List<ConnectivityResult> result) {
    _isConnected.value =
        result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }
}