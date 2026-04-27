import '../../../../core/network/api_client.dart';
import '../models/product_detail_model.dart';

abstract class ProductDetailRemoteDataSource {
  Future<ProductDetailModel> getProductDetail(String productId);
}

class ProductDetailRemoteDataSourceImpl implements ProductDetailRemoteDataSource {
  ProductDetailRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static String _productPath(String productId) =>
      '/store/mobile/products/$productId';

  @override
  Future<ProductDetailModel> getProductDetail(String productId) async {
    final response = await _apiClient.get(_productPath(productId));
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException('Invalid product response');
    }
    return ProductDetailModel.fromMobileApiResponse(data);
  }
}
