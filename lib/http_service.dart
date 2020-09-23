import 'dart:convert' as converter;

import 'package:http/http.dart' as http;

class Response {
  final http.Response response;
  int status;

  Response(
    this.response,
  ) : status = response.statusCode;

  bool isJSON() {
    return response.headers['Content-Type'].contains("json");
  }

  dynamic json() {
    return converter.json.decode(response.body);
  }
}

Future<Map<String, String>> getAuthorizationHeaders() async {
  // // final user = Registry.get("user");
  // print("sending");
  // print(user);
  // if (user == null || user['token'] == null)
  //   return {"Authorization": "Bearer "};

  // return {"Authorization": "Bearer " + user['token']};
  return <String, String>{};
}

Future<Response> get(url, {Map<String, String> headers}) async {
  print("get request $url");

  if (headers == null) headers = {};
  headers.addAll(await getAuthorizationHeaders());
  print("get request $url");
  try {
    final res = await http.get(url, headers: headers);
    return Response(res);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Response> post(url,
    {Map<String, String> headers, body, converter.Encoding encoding}) async {
  if (headers == null) headers = {};

  headers.addAll(await getAuthorizationHeaders());
  print("post request $url $body $headers");
  try {
    final res =
        await http.post(url, headers: headers, body: body, encoding: encoding);
    return Response(res);
  } catch (e) {
    print(e);
    return null;
  }
}
