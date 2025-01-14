import 'package:flutter_test/flutter_test.dart';

import 'package:nominatim_geocoding/nominatim_geocoding.dart';

void main() async {
  await NominatimGeocoding.init();
  test('Check forward geocoding', () async {
    final result = await NominatimGeocoding.to.forwardGeoCoding(
      const Address(
        city: 'Braunschweig',
        postalCode: 38120,
      ),
    );
    expect(result.address.city, 'Braunschweig');
  });
  test('Check reverse geocoding', () async {
    final result = await NominatimGeocoding.to.reverseGeoCoding(
      const Coordinate(
          latitude: 52.27429313260939, longitude: 10.523078303155874),
    );
    expect(result.address.city, 'Braunschweig');
  });
}
