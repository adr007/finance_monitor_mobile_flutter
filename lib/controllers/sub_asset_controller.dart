// import 'package:adr_finance_app/models/sub_asset.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:get/state_manager.dart';

class SubAssetController extends GetxController {
  var isLoading = true.obs;
  var subAssetList = List<dynamic>().obs;
  Data data = Data();

  @override
  void onInit() {
    // TODO: implement onInit
    fetchSubAsset();
    super.onInit();
  }

  @override
  void refresh() {
    // TODO: implement refresh
    fetchSubAsset();
    super.refresh();
  }

  void fetchSubAsset() async {
    try {
      isLoading(true);
      var subAsset = await data.getSubAsset();
      if(subAsset != null) {
        subAssetList.value = subAsset;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}