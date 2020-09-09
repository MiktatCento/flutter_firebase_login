import 'package:http/http.dart' as http;

class Func {

  Future<String> getIp() async {
    final response = await http.get('https://api.ipify.org/');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get ip');
    }
  }
  
}