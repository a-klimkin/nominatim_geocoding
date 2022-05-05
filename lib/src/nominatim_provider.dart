import 'package:get/get.dart';

import 'model/coordinate.dart';
import 'model/geocoding.dart';

/// [NominatimProvider] provider class to call OSM nominatim API
/// docs at `https://nominatim.org/release-docs/develop/`.
class NominatimProvider extends GetConnect {
  /// Get provider object. Stictly use this getter to create object.
  static NominatimProvider get to => Get.find();

  /// Forward geocoding path for the API.
  static const String forwardPath = '/search';

  /// Reverse geocoding path for the API.
  static const String reversePath = '/reverse';

  @override
  void onInit() {
    httpClient.baseUrl = 'https://nominatim.openstreetmap.org';
    httpClient.defaultContentType = 'application/json; charset=utf-8';
    httpClient.defaultDecoder = (data) {
      return data is Map<String, dynamic> &&
              data.containsKey('lat') &&
              data.containsKey('lon') &&
              data.containsKey('address')
          ? Geocoding.fromJson(data)
          : data is List &&
                  data[0] is Map<String, dynamic> &&
                  data[0].containsKey('lat') &&
                  data[0].containsKey('lon') &&
                  data[0].containsKey('address')
              ? Geocoding.fromJson(data[0])
              : data;
    };
    httpClient.sendUserAgent = true;
    httpClient.userAgent = 'Flutter-Nominatim-Skymind-Package';

    super.onInit();
  }

  /// API call for the forward geocoding with address query.
  Future<Response<dynamic>> forwardRequest(String queryAddress) => get(
        forwardPath,
        query: {
          'q': queryAddress,
          'format': 'json',
          'addressdetails': '1',
        },
      );

  /// API call for the reverse geocoding with coordinates query.
  Future<Response<dynamic>> reverseRequest(Coordinate coordinate, [String? local]) => get(
        reversePath,
        query: {
          ...coordinate.toJson(),
          'format': 'json',
          'addressdetails': '1',
          if (local != null)
            'accept-language': local,
        },
      );
}
