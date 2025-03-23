extension CastObject on Object {
  T cast<T>() {
    return this as T;
  }
}

extension CastNullableObject on Object? {
  T? cast<T>() {
    return this == null ? null : this as T;
  }
}
