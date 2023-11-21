import 'package:http/http.dart' as http;
import 'dart:convert';

class YandexDiskApi {
  static const String _disk = '/v1/disk';
  static const String _resources = '$_disk/resources';

  final Uri _baseUrl;
  final Map<String, String> _authHeader;

  YandexDiskApi(final String baseUrl, final String accessToken)
      : _baseUrl = Uri.parse(baseUrl),
        _authHeader = {'Authorization': 'OAuth $accessToken'};

  /// Create the folder.
  /// See: https://yandex.ru/dev/disk/api/reference/create-folder.html
  Future<int> createFolder(final String path) async {
    final Uri uri = Uri.https(_baseUrl.host, _resources, {'path': path});
    final res = await http.put(uri, headers: _authHeader);
    return res.statusCode;
  }

  /// Upload the file.
  /// See: https://yandex.ru/dev/disk/api/reference/upload.html
  Future<int> uploadFile(final String path, final Object data) async {
    final Uri uri = Uri.https(_baseUrl.host, '$_resources/upload', {'path': path});
    var res = await http.get(uri, headers: _authHeader);
    if (res.statusCode != 200) {
      return res.statusCode;
    }

    var link = jsonDecode(res.body);
    var uploadUri = Uri.parse(link['href'].toString());
    res = await http.put(uploadUri, body: data);
    return res.statusCode;
  }

  Future<List<String>> filesInFolder(final String path) async {
    final Uri uri = Uri.https(_baseUrl.host, _resources, {'path': path});
    final res = await http.get(uri, headers: _authHeader);

    print("filesInFolder status: ${res.statusCode}");
    if (res.statusCode != 200) {
      return <String>[];
    }

    List<String> files = [];
    var meta = jsonDecode(res.body);
    var items = meta["_embedded"]["items"];
    for (var item in items) {
      if (item["type"] == "file") {
        files.add(item["name"].toString());
      }
    }

    return files;
  }
}
