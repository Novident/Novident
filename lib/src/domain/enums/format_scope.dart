/// This enum is automatically added by Novident and the user shouldn't have this option available
enum FormatScope {
  novident, // Saying to app this format is from the app
  global, // Saying to app this format is from the user creation
  project, // Saying to app this format is from the user creation but is limited to just the project
  unknown, // it shouldn't be used but, it could be used on the future
  noScope, // This scope is just reserved by Default layout
}
