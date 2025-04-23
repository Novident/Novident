class ProjectStatusResponse {
  final bool isValid;
  final String? failReason;

  ProjectStatusResponse({
    required this.isValid,
    required this.failReason,
  });
}
