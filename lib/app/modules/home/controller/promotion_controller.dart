import 'package:get/get.dart';
import 'package:avianicare/app/modules/home/model/promotion_model.dart';
import 'package:avianicare/app/modules/promotion/model/promotion_wise_product.dart';
import 'package:avianicare/data/remote_services/remote_services.dart';

class PromotionalController extends GetxController {
  final isLoading = false.obs;
  final loading = false.obs;
  final promotionModel = PromotionModel().obs;
  final multiPromotionModel = PromotionModel().obs;
  final promotionProductModel = PromotionWiseProductModel().obs;
  final promotionProductLoader = false.obs;

  Future<void> fetchPromotion() async {
    isLoading(true);
    final data = await RemoteServices().fetchPromotion();
    isLoading(false);
    data.fold((error) => error.toString(), (promotion) {
      promotionModel.value = promotion;
    });
  }

  Future<void> fetchMultiPromotion() async {
    loading(true);
    final data = await RemoteServices().fetchMultiPromotion();
    loading(false);
    data.fold((error) => error.toString(), (promotion) {
      multiPromotionModel.value = promotion;
    });
  }

  Future<void> fetchPromotionWiseProduct(
      {required String promotionSlug}) async {
    promotionProductLoader.value = true;
    final result = await RemoteServices()
        .fetchPromotionWiseProduct(promotionSlug: promotionSlug);

    print("Result = $result");

    promotionProductLoader.value = false;

    result.fold((error) {
      promotionProductLoader.value = false;
      print(error);
    }, (data) {
      promotionProductLoader.value = false;
      promotionProductModel.value = data;
    });
  }

  @override
  void onInit() {
    fetchPromotion();
    fetchMultiPromotion();
    super.onInit();
  }
}
