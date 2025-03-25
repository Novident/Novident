import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_manager.dart';

class ProjectConfigurations {
  final bool placeholderDisabled;
  final SectionManager sectionManager;
  final Format? format;

  ProjectConfigurations({
    required this.sectionManager,
    this.format,
    this.placeholderDisabled = false,
  });

  @override
  bool operator ==(covariant ProjectConfigurations other) {
    if (identical(this, other)) return true;
    return sectionManager == other.sectionManager &&
        format == other.format &&
        placeholderDisabled == other.placeholderDisabled;
  }

  @override
  int get hashCode =>
      sectionManager.hashCode ^ format.hashCode ^ placeholderDisabled.hashCode;
}
