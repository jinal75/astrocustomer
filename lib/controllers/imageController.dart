//flutter
//packages
import 'package:get/get.dart';
//contoller
import 'package:AstroGuru/controllers/networkController.dart';

class ImageControlller extends GetxController {
  NetworkController networkController = Get.find<NetworkController>();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
