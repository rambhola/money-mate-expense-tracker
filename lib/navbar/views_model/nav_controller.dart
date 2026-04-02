import 'package:get/get.dart';
class NavController extends GetxController{
  RxInt selectedIndex = 0.obs;

  @override
  void onInit(){
    super.onInit();
    selectedIndex.value - 0;
  }
}