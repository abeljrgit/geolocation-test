import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ArcgisApi {
  final Dio _dio = Dio();
  final String _argisGeocodeUrl = 'https://geocode.arcgis.com';
  final String _argisApiKey = dotenv.env['ARCGIS_API_KEY'] ?? '';

  dynamic getReversedGeocode(String latitude, String longitude) async {
    try {
      Response response = await _dio.get(
          '$_argisGeocodeUrl/arcgis/rest/services/World/GeocodeServer/reverseGeocode?token=$_argisApiKey&f=json&location=$longitude,$latitude');
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
