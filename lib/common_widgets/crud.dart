import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsbody = jsonDecode(response.body);
        return responsbody;
      } else {
        print("Error${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  postrequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsbody = jsonDecode(response.body);
        return responsbody;
      } else {
        print("Error${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }
}
