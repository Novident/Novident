extension NonNegativeNumOperations on int {
  int nonNegativeDecrease() {
    return (this - 1).nonNegative();
  }
}

extension NonNegative on int {
  int nonNegative() {
    return this < 0 ? 0 : this;
  }
}

extension NonNegativeDouble on double {
  double nonNegative() {
    return this < 0 ? 0 : this;
  }
}
