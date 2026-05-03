import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? undertone;

  @HiveField(3)
  String? season;

  @HiveField(4)
  String? profileImage;

  User({
    required this.name,
    required this.email,
    this.undertone,
    this.season,
    this.profileImage,
  });
}