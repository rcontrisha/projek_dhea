import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  TodoModel({required this.username, required this.password});
}
