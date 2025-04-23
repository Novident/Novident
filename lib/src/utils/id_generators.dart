import 'package:uuid/v1.dart';
import 'package:uuid/v4.dart';
import 'package:uuid/v6.dart';
import 'package:uuid/v7.dart';

class IdGenerator {
  const IdGenerator._();
  static const UuidV1 v1 = UuidV1();
  static const UuidV4 v4 = UuidV4();
  static const UuidV6 v6 = UuidV6();
  static const UuidV7 v7 = UuidV7();

  static String gen({int version = 1}) {
    version = version.clamp(1, 7);
    switch (version) {
      case 1:
        return v1.generate();
      case 4:
        return v4.generate();
      case 6:
        return v6.generate();
      case 7:
        return v7.generate();
      default:
        return v1.generate();
    }
  }
}
