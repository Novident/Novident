import 'package:novident_remake/src/domain/entities/project/section/section_manager.dart';

class ProjectConfigurations {
  final SectionManager sectionManager;

  ProjectConfigurations({
    required this.sectionManager,
  });

  @override
  bool operator ==(covariant ProjectConfigurations other) {
    if (identical(this, other)) return true;
    return sectionManager == other.sectionManager;
  }

  @override
  int get hashCode => sectionManager.hashCode;
}
