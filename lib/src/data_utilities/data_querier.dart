import 'package:http/http.dart' as http;

class DataQuerier {

  static Future<WearableInfo> getInfo(bool drinkingAlcohol, bool takingDrugs) {
    String url = "https://night-guard-backend.herokuapp.com/get_data";
    return http.get(Uri.parse(url)).then(
        (response) {
          String response_body = response.body;
          print(response_body);
          List<String> values = response_body.split(',');
          return WearableInfo(
              double.parse(values[2]).toInt(),
              double.parse(values[0]),
              double.parse(values[1]),
              int.parse(values[3]) > 0.5
          );
        }
    );
  }
}

class WearableInfo {
  final int heartRate;
  final double bloodPressure;
  final double bodyTemp;
  final bool spiked;

  WearableInfo(this.heartRate, this.bloodPressure, this.bodyTemp, this.spiked);
}