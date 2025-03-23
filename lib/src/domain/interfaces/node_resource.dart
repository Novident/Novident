/// All the classes that implements this mixin
/// the compiler will take them as a resource
/// that should be counted to get an image/video/formula, etc;
mixin NodeHasResource {
  /// This checks first is the Node follows the Resource standard
  bool get isResource;

  /// This get the resource
  Object? resource(ResourceType type);
}

enum ResourceType {
  image,
  video,
  formula,
  hyperlink,
}
