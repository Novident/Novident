abstract class EditorService<T, R> {
  /// Determines whether we should execute the service at this time
  bool shouldExecute(T data);

  /// Sometimes, we can expect just changing partial parts
  /// of the service, instead of loading the whole data
  /// making a lot of work, when we can just update certain
  /// parts improving the perfomance
  void onLoadNewData(Object? oldState, Object newState) {}

  /// Executes the data and get the Result that the implementation
  /// want
  R execute(T data);
}
