/// An internal object that allow to us create a final value
/// that can mutate its state without affect to its immutable parent
class ObjectValue<T> {
  T value;
  ObjectValue({required this.value});

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(covariant ObjectValue<T> other) {
    if (identical(this, other)) return true;
    return value == other.value;
  }

  @override
  String toString() {
    return value.toString();
  }
}
