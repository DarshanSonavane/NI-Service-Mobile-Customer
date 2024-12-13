import 'package:hive/hive.dart';

Future<void> clearUserBox() async {
  var box = await Hive.openBox<List<String>>('userBox');
  await box.clear();
  await box.close();
}
