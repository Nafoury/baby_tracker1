import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

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

  postRequest(String url, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multiplepartfile = http.MultipartFile("file", stream, length,
        filename: basename(file.path));
    request.files.add(multiplepartfile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myrequest = await request.send();

    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error ${myrequest.statusCode}");
    }
  }
}
