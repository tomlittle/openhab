class OHConfig {
  final String baseUrl;
  List<String> listOfSwitches = [];
  List<String> listOfStrings = [];
  List<String> listOfSuffixes = [];

  OHConfig({
    required this.baseUrl
  });

  String itemUrl (String itemName) {
    return baseUrl+'/rest/items/'+itemName;
  }

}

OHConfig getConfiguration () {
  OHConfig ohConfig = OHConfig(baseUrl: 'http://172.20.11.1:8080');
  ohConfig.listOfSwitches = ['OUT_Lamp'];
  ohConfig.listOfStrings = ['localWeather_OutsideTemp','localWeather_OutsideHum','localWeather_Pressure','localWeather_WindSpeed'];
  ohConfig.listOfSuffixes = ['°C','%','mbar','kmh'];
  return ohConfig;
}