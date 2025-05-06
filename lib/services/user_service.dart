import 'dart:convert';
import 'package:asisten_tpm_8/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static const url = "https://be-rest-872136705893.us-central1.run.app/users";

  static Future<Map<String, dynamic>> getUsers() async {
    final http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createUser(UserModel user) async {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'name': user.name,
        'email': user.email,
        'gender': user.gender,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateUser(UserModel user) async {
    final http.Response response = await http.put(
      Uri.parse("$url/${user.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'name': user.name,
        'email': user.email,
        'gender': user.gender,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteUser(String id) async {
    final http.Response response = await http.delete(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }
}
