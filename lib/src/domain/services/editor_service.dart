abstract class EditorService<T, R> {
  bool shouldExecute(T data);
  R execute(T data);
}
