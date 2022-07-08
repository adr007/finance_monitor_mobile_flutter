import 'package:adr_finance_app/services/data.dart';
import 'package:get/state_manager.dart';

class TransactionController extends GetxController {
  var isLoading = true.obs;
  var transList = <dynamic>[].obs;
  Data data = Data();

  @override
  void onInit() {
    // TODO: implement onInit
    fetchTransaction();
    super.onInit();
  }

  @override
  void refresh() {
    // TODO: implement refresh
    fetchTransaction();
    print(transList);
    super.refresh();
  }

  void fetchTransaction() async {
    try {
      isLoading(true);
      var trans = await data.getTransaction();
      if(trans != null) {
        transList.value = trans;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}