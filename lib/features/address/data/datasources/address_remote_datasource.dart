import '../../../../core/network/api_client.dart';
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> createAddress(AddressModel model);
  Future<void> updateAddress(String id, AddressModel model);
  Future<void> deleteAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  AddressRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static const String _path = '/store/mobile/addresses';

  List<Map<String, dynamic>> _parseAddressList(dynamic data) {
    List<dynamic> raw = const [];
    if (data is List) {
      raw = data;
    } else if (data is Map<String, dynamic>) {
      final nested = data['addresses'] ?? data['data'] ?? data['items'];
      if (nested is List) {
        raw = nested;
      }
    }
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Merges top-level fields (`id`, …) with nested `address` when the API
  /// nests street/city under `address`.
  Map<String, dynamic> _unwrapAddressItem(Map<String, dynamic> m) {
    final inner = m['address'];
    if (inner is Map) {
      final merged = Map<String, dynamic>.from(m);
      merged.addAll(Map<String, dynamic>.from(inner));
      return merged;
    }
    return m;
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiClient.get(_path);
    final maps = _parseAddressList(response.data);
    return maps
        .map(_unwrapAddressItem)
        .map(AddressModel.fromMobileApiJson)
        .toList();
  }

  @override
  Future<void> createAddress(AddressModel model) async {
    await _apiClient.post(
      _path,
      data: model.toMobileCreateOrUpdateBody(),
    );
  }

  @override
  Future<void> updateAddress(String id, AddressModel model) async {
    await _apiClient.post(
      '$_path/$id',
      data: model.toMobileCreateOrUpdateBody(),
    );
  }

  @override
  Future<void> deleteAddress(String id) async {
    await _apiClient.delete('$_path/$id');
  }
}
