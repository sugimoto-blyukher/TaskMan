import 'package:uuid/uuid.dart';

class IdGenerator {
  static const _uuid = Uuid();
  static String create() => _uuid.v4();
}
