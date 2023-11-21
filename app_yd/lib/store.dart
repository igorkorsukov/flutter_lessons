import 'package:english_words/english_words.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'kors_yandex_disk.dart';

class Store {
  final _token = dotenv.env['YA_DISK_DEV_TOKEN'] ?? '';
  late final _api = YandexDiskApi('https://cloud-api.yandex.net', _token);

  void init() async {
    try {
      int status = await _api.createFolder('app:/favorites');
      print("createFolder status: $status");
    } catch (e) {
      print("catch: $e");
    }
  }

  Future<void> test1() async {}

  List<WordPair> loadItems() {
    var pairs = <WordPair>[];
    try {
      Future<List<String>> fi = _api.filesInFolder('app:/favorites/');
      fi.then((list) {
        print(list);
        for (var file in list) {
          var p = WordPair(file, 'x');
          pairs.add(p);
        }
      });
    } catch (e) {
      print("catch: $e");
    }

    return pairs;
  }

  void addItem(WordPair item) async {
    var name = item.asLowerCase;
    try {
      int status = await _api.uploadFile('app:/favorites/$name', '{}');
      print("uploadFile status: $status");
    } catch (e) {
      print("catch: $e");
    }
  }

  void deleteItem(WordPair item) {}
}
