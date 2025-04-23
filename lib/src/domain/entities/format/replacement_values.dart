class ReplacementsValues {
  final Set<Replacement> replacements;

  ReplacementsValues({
    required this.replacements,
  });
}

class Replacement {
  final String matchCase;
  final String replacement;
  final bool enabled;
  final bool isRegexp;
  final bool caseSensitive;

  Replacement({
    this.matchCase = '',
    this.replacement = '',
    this.enabled = false,
    this.isRegexp = false,
    this.caseSensitive = true,
  });

  RegExp? get regexp => !isRegexp
      ? null
      : RegExp(
          matchCase,
          caseSensitive: caseSensitive,
        );
}
