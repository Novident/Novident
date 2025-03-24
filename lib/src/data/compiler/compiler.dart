import 'package:novident_remake/src/domain/enums/enums.dart';

abstract class Compiler<T, B> {
  CompileTo get typeCompilation;
  B build(T data);
}
