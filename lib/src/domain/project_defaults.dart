/// This class contains all the default variables that are used when some
/// values are not passed by the user or something fails and these are used
/// to avoid exception calls
///
/// To maintain a retrocompatibility with older version, we need to avoid
/// change them
class ProjectDefaults {
  const ProjectDefaults._();
  static const String kStructuredBasedSectionId =
      "018dbf0d-f756-7c76-8e46-c33daa3ca236687ae53e-339c-4eac-9dc5-7450b2554b01";
  static const String kDefaultUnnamedDocument = 'Untitled document';
  static const String kDefaultUnnamedDirectory = 'Untitled directory';
  static const String kDefaultUnnamedProject = 'Untitled';
  static const String kDefaultUnnamedTemplate = 'Untitled template';
  static const String kDefaultUnnamedLayout = 'Untitled layout';
  static const String kDefaultUnnamedFormat = 'Untitled format';
  static const String kDefaultUnnamedCategory = 'Untitled category';
  static const String kDefaultUnnamedFile = 'Untitled file';
  static const String kDefaultProjectRootPath = '%USERPROJECT%';
  static const String kDefaultFolderPath = '%USERFOLDER%';
  static const String kDefaultDocumentPath = '%USERDOCUMENT%';
  static const String kDefaultFrontMatterName = "Front Matter";
  static const String kDefaultBackMatterName = "Back Matter";
  static const String kDefaultManuscriptName = "Draft";
  static const String kDefaultBasicLayoutName = "As is";
  static const String kDefaultLayoutNewlineRepresentation = '¶';

  /// this is used by the app to generate the file only recognized by the project
  ///
  /// the file should looks like:
  /// ```
  /// file.novid
  /// ```
  static const String kDefaultProjectExtension = "novid";

  /// Reset placeholder invokation. When this is founded
  /// all the placeholders will restart their counts
  static final RegExp kResetCountsInvokation = RegExp(
    r'<\$'
    // the keyword to invoke reset index fn
    'rst'
    // match with the localname of the supported index placeholders
    '(?<indexType>sn|n|N|t|w|W|r|R|all)'
    // match with the text after the reset invokation
    //
    // this part is essential, because, if the placeholder contains
    // an specific reference to an index group name, we only need to reset
    // that placeholder, not all the tags that implements the matched one
    //
    // If you have a placeholder invokation like:
    //
    // ```console
    //  <$n:scene>
    // ```
    //
    // and, you want to reset the index count after the invokation
    // you will need to create a reset invokation like
    //
    // ```console
    //  <$rst_n:scene>
    // ```
    //
    // Then, this will reset index of the next documents that uses `<$n:scene>`
    '(_'
    // this is the part after the `:X`
    '(?<indexGroup>.+?)'
    ')?>',
  );

  /// Double Numbering placeholder that matches with all the
  /// tags like: <$dn> | <$dn:X>
  static final RegExp kDoubleNumCountPattern = RegExp(
    r'(<\$'
    // at this part, to simplifies that tasks
    //
    // * <$dn> means, that the user want to get the word num index in lowercase (<$dn>, <$dn>, <$dn> => '1.1, 1.2, 1.3')
    '(?<indexType>dn)'
    '(:'
    // match with all the characters after ":"
    //
    // that means, if we creates a placeholder like:
    // * <$n:scene> will get exact group called => "scene"
    r'[\w\d]+)?>'
    ')',
  );

  /// Numbering placeholder that matches with all the
  /// tags like: <$n> | <$n:X>
  static final RegExp kNumCountPattern = RegExp(
    r'(<\$'
    // at this part, to simplifies that tasks
    //
    // * <$n> means, that the user want to get the word num index in lowercase (<$n>, <$n>, <$n> => '1, 2, 3')
    '(?<indexType>n)'
    '(:'
    // match with all the characters after ":"
    //
    // that means, if we creates a placeholder like:
    // * <$n:scene> will get exact group called => "scene"
    r'[\w\d]+)?>'
    ')',
  );

  /// Subnumbering placeholder that matches with all the
  /// tags like: <$sn> | <$sn:X>
  static final RegExp kSubNumberingCountPattern = RegExp(
    r'(<\$'
    // The same as <$n> but intended to be used for sub-numbering. The count
    // restarts each time an <$n> placeholder is encountered. Thus, “<$n> (<$sn>,
    // <$sn>), <$n> (<$sn>, <$sn>)” would become “1 (1, 2), 2 (1, 2)” in the compiled
    // text.
    '(?<indexType>sn)'
    '(:'
    // match with all the characters after ":"
    //
    // that means, if we creates a placeholder like:
    // * <$sn:scene> will get exact group called => "scene"
    r'[\w\d]+)?>'
    ')',
  );

  /// Word numbering placeholder that matches with all the
  /// tags like: <$w> | <$w:X> | <$W> | <$W:X>| <$t> | <$t:X>
  static final RegExp kWordNumCountPattern = RegExp(
    r'(<\$'
    // at this part, to simplifies that tasks
    // and to avoid add too much rules
    // we wrapped all these keywords
    //
    // * <$w> means, that the user want to get the word num index in lowercase (<$w>, <$w>, <$w> => 'one', 'two', 'three')
    // * <$W> means, that the user want to get the word num index in uppercase (<$W>, <$W>, <$W> => 'ONE', 'TWO', 'THREE')
    // * <$t> means, that the user want to get the word num index in titlecase (<$t>, <$t>, <$t> => 'One', 'Two', 'Three')
    '(?<indexType>w|W|t)'
    '(:'
    // match with all the characters after ":"
    //
    // that means, if we creates a placeholder like:
    // * <$w:scene> will get exact group called => "scene"
    r'[\w\d]+)?>'
    ')',
  ); // lower/upper/title case word

  /// Datetime day placeholder that matches with all the
  /// tags like: <$day>
  static final RegExp kDayPattern = RegExp(
    r'<\$day>',
  );

  /// Datetime weekday placeholder that matches with all the
  /// tags like: <$weekday>
  static final RegExp kWeekdayPattern = RegExp(
    r'<\$weekday>',
  );

  /// Datetime millisecond placeholder that matches with all the
  /// tags like: <$millisecond>
  static final RegExp kMillisecondPattern = RegExp(
    r'<\$millisecond>',
  );

  /// Datetime microsecond placeholder that matches with all the
  /// tags like: <$microsecond>
  static final RegExp kMicrosecondPattern = RegExp(
    r'<\$microsecond>',
  );

  /// Datetime minute placeholder that matches with all the
  /// tags like: <$minute>
  static final RegExp kMinutePattern = RegExp(
    r'<\$minute>',
  );

  /// Datetime hour format placeholder that matches with all the
  /// tags like: <$hms>
  static final RegExp kHourFormatPattern = RegExp(
    r'<\$hms>',
  );

  /// Datetime second placeholder that matches with all the
  /// tags like: <$second>
  static final RegExp kSecondPattern = RegExp(
    r'<\$second>',
  );

  /// Datetime year placeholder that matches with all the
  /// tags like: <$year>
  static final RegExp kYearPattern = RegExp(
    r'<\$year>',
  );

  /// Datetime hour placeholder that matches with all the
  /// tags like: <$hour>
  static final RegExp kHourPattern = RegExp(
    r'<\$hour>',
  );

  /// Datetime today placeholder that matches with all the
  /// tags like: <$today>
  static final RegExp kTodayPattern = RegExp(
    r'<\$today>',
  );

  /// Datetime exact month placeholder that matches with all the
  /// tags like: <$month> | <$month:n>
  static final RegExp kMonthsPattern = RegExp(
    '(<\$'
    '(?<indexType>month)'
    '(:'
    // match with all the characters after ":"
    'n)?>'
    ')',
  );

  /// Roman numbering placeholder that matches with all the
  /// tags like: <$r> | <$r:X> | <$R> | <$R:X>
  static final RegExp kRomanWordNumIndexPattern = RegExp(
    r'(<\$'
    // at this part, to simplifies that tasks
    // and to avoid add too much rules
    // we wrapped all these keywords
    //
    // * <$r> means, that the user want to get the roman num count in lowercase (<$r>, <$r>, <$r> => 'i', 'ii', 'iii')
    // * <$R> means, that the user want to get the roman num count in uppercase (<$W>, <$W>, <$W> => 'I', 'II', 'III')
    '(?<indexType>r|R)'
    '(:'
    // match with all the characters after ":"
    //
    // that means, if we creates a placeholder like:
    // * <$r:scene> will get exact group called => "scene"
    r'[\w\d]+)?>'
    ')',
  );

  /// Word count placeholder that matches with all the
  /// tags like: <$wc> | <$wc50> | <$wc100> | <$wc500> | <$wc1000>
  static final RegExp kWordCountPattern = RegExp(
    r'<\$'
    // match with the keyboard that correspond to the
    // word count service invokation
    'wc'
    // Official documentation this part is the total word count of the text
    //  that will be rounded to the nearest <ammount_passed> words.
    //
    // Currently, we only suppors: [50, 100, 500, 1000] limits
    //
    // this part is marked as optional, since we can
    // just pass <$wc> and will work with no issues
    r'(50|100|500|1000)?'
    '>',
  );

  /// Character count placeholder that matches with all the
  /// tags like: <$wc> | <$wc50> | <$wc100> | <$wc500> | <$wc1000>
  static final RegExp kCharacterCountPattern = RegExp(
    r'<\$'
    // match with the keyboard that correspond to the
    // word count service invokation
    'cc'
    // Official documentation this part is the total characters count of the text
    //  that will be rounded to the nearest <ammount_passed> words.
    //
    // Currently, we only suppors: [50, 100, 500, 1000] limits
    //
    // this part is marked as optional, since we can
    // just pass <$wc> and will work with no issues
    r'(50|100|500|1000)?'
    '>',
  );

  /// Linecount placeholder that matches with all the
  /// tags like: <$linecount>
  static final RegExp kLineCountPattern = RegExp(
    '<\$linecount>',
  );

  /// Abbreviate title placeholder that matches with all the
  /// tags like: <$abbr_title> | <$abbr_projectname> | <$abbr_projecttitle>
  /// <$ABBR_TITLE> | <$ABBR_PROJECTNAME>, etc
  static final RegExp kAbbreviateTitlePattern = RegExp(
    // Gets replaced with the abbreviated project name during the Compile process.
    // The abbreviated project name is taken from metadata pane of the Compile panel.
    //
    // If the placeholder appears in uppercase, the abbreviated project name will be
    // uppercased too.
    r'<\$('
    '('
    // lowercase abbreviate title
    '(abbr_(title|projectname|projecttitle))'
    '|'
    // uppercase abbreviate title
    '(ABBR_(TITLE|PROJECTNAME|PROJECTTITLE))'
    ')'
    ')>',
  );

  /// project title placeholder that matches with all the
  /// tags like: <$projectname> || <$projecttitle>
  static final RegExp kProjectTitlePattern = RegExp(
    '<\$(projectname|projecttitle|PROJECTNAME|PROJECTTITLE)>',
  );

  /// document title placeholder that matches with all the
  /// tags like: <$doc_title>
  static final RegExp kDocumentTitlePattern = RegExp(
    '<\$(doctitle|DOCTITLE)>',
  );

  /// isbn placeholder that matches with all the
  /// tags like: <$iscode>
  static final RegExp kISBNCodeTitlePattern = RegExp(
    '<\$(iscode|ISCODE)>',
  );

  /// author placeholder that matches with all the
  /// tags like: <$author>
  ///
  /// If you want to get the full name of a exact
  /// author (only when you have more than one)
  /// You can pass a index the placeholder
  ///
  /// Example:
  ///
  /// When we have in our authors field, something like:
  ///
  /// ```
  /// "Author One, Author Two, Author Three"
  /// ```
  /// To reference some of then
  ///
  /// ```
  ///  <$lastname:2>, <$fullname:3>
  /// ```
  ///
  /// And, after the compile, you can see this:
  ///
  /// "Two, Author Three"
  ///
  /// By default, if you dont pass a index
  /// the author will get only the first author values.
  ///
  /// To get all the authors at the same time
  /// you will need to write a placeholder like:
  ///
  /// ```
  ///  <$author:all>
  /// ```
  static final RegExp kAuthorPattern = RegExp(
    r'<\$('
    // lowecase
    'author'
    '|'
    'lastname'
    '|'
    'fullname'
    '|'
    'firstname'
    '|'
    'forename'
    '|'
    'surname'
    '|'
    //uppercase
    'AUTHOR'
    '|'
    'FULLNAME'
    '|'
    'LASTNAME'
    '|'
    'FIRSTNAME'
    '|'
    'FORENAME'
    '|'
    'SURNAME'
    // this match with the index of the author that we want
    // to insert
    ')'
    '(:([0-9]|all))?'
    '?>',
    caseSensitive: true,
  );

  //TODO: implement its rule
  /// include placeholder that matches with all the
  /// tags like: <$include:docPath> || <$include:docName>
  static final RegExp kIncludePattern = RegExp(
    // You can use the <$include...> placeholder to have text from an external
    // document inserted into the text during Compile. This can be useful if you have
    // text snippets that need repeating throughout for some reason.
    // document links is the more reliable method.)
    //
    // To insert the main text of any document in the current project, either use the
    // <$include> tag and apply a document link to the whole tag that points to the
    '<\$(?<indexType>include)'
    r'(:'
    // document whose text you wish to insert, or use <$include:docName>, where
    // “docName” is the name of the document you wish to be inserted.
    //
    // Like: <$include:docTitle>
    r'([\w\d]+)'
    ')?>',
    caseSensitive: false,
  );

  /// Image placeholder that matches with all the
  /// tags could like: <$img:DocName> | <$img:DocPath> | <$img:X:contain>
  static final RegExp kImagePattern = RegExp(
    r'<\$'
    // You can use the <$img…> placeholder to have images inserted into your text
    // during Compile. This can be useful if you want to insert an image into a title prefix
    // or suffix, if you want to keep images out of the text while writing, or if you want to
    // include certain images only conditionally (you could use the “Replacements”
    // pane of Compile to remove image placeholders for images you don’t want to
    // appear in a particular Compile format, for instance).
    //
    // Image placeholders support image documents that have been imported into the
    // project - in which case you should use the name of the document on its own - or
    // file paths to images on disk. For instance:
    //
    // * <$img:My Image Document>
    // * <$img:~/Pictures/My Image File.png>
    'img:'
    // this match with the source of the image
    //
    // it can looks like:
    //
    // * <$img:DocumentName>
    '(.+?)'
    '(:'
    // attributes part
    '(?<fitType>'
    r'(cover|'
    r'contain|'
    r'fill|'
    r'fitWidth|'
    r'fitHeight|'
    r'fill-all|'
    r'none|'
    r'scale-down)'
    ')'
    ')?>',
  );
}
