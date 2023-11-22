import 'package:english_words/english_words.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kors_yandexdisk_fs/yandexdisk_fs.dart';

class Store {
  final _token = dotenv.env['YA_DISK_DEV_TOKEN'] ?? '';
  late final _ydfs = YandexDiskFS('https://cloud-api.yandex.net', _token);

  void init() async {
    try {
      await _ydfs.makeDir('app:/favorites');
    } catch (e) {
      print("catch: $e");
    }
  }

  Future<void> test1() async {}

  Future<List<WordPair>> loadItems() async {
    var pairs = <WordPair>[];
    try {
      List<String> list = await _ydfs.scanFiles('app:/favorites/');
      print(list);
      for (var file in list) {
        var p = WordPair(file, 'x');
        pairs.add(p);
      }
    } catch (e) {
      print("catch: $e");
    }

    return pairs;
  }

  void addItem(WordPair item) async {
    var name = item.asLowerCase;
    try {
      await _ydfs.writeFile('app:/favorites/$name', '{}');
    } catch (e) {
      print("catch: $e");
    }
  }

  void deleteItem(WordPair item) async {
    var name = item.asLowerCase;
    try {
      await _ydfs.remove('app:/favorites/$name');
    } catch (e) {
      print("catch: $e");
    }
  }
}
