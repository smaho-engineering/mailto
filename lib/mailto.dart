import 'package:meta/meta.dart';

/// Specifies how [Mailto] performs validation.
enum MailtoValidate {
  /// Validation always called whenever a [Mailto] instance's toString method
  /// is called.
  ///
  /// In this mode, the validation might throw [ArgumentError]s even in your
  /// production release.
  enabled,

  /// Validation is called when a [Mailto] instance is created in `assert` mode.
  ///
  /// You can read more about
  /// [assert in the Dart Language Tour](https://dart.dev/guides/language/language-tour#assert).
  ///
  /// In short, in this mode, we expect you to fix your input during development
  /// so that error handling is not required. Perfect for const, static input.
  viaAssertions,

  /// The validation by the package is never called.
  ///
  /// Please be aware that the validation is added to the package so that
  /// the behavior of the package is more predictable. If you turn off
  /// validation, the package might not be able to create
  /// working mailto links, so we discourage turning validation off.
  /// Turning off the validation might cause issues that would otherwise
  /// be quite easy to solve.
  ///
  /// With that said, this method might be necessary, if you disagree with
  /// how we validate input. Just turn off validation, and you are free to use
  /// any input you wish.
  ///
  /// If you find problems with the existing validation, please open an issue,
  /// so that we can address your issues.
  never,
}

/// [Mailto] helps you create email ("mailto") links.
///
/// The class takes care of all the necessary encoding.
///
/// You can use the `url_launcher` package for launching the
/// URL that the [Mailto] class's [toString] method returns.
/// It will open the default email client on the smart phone,
/// with pre-filled [to], [cc], [bcc] recipient list, [subject], and [body]
/// (content of the email).
///
/// The user can still decide not to send an email or edit any of the
/// fields.
class Mailto {
  /// Create a [Mailto] instance.
  ///
  /// Input is validated only development mode (via assert). It is assumed
  /// that these argument errors are fixed during development. Otherwise,
  /// the toString method might generate incorrect mailto URIs.
  Mailto({
    @required this.to,
    this.cc,
    this.bcc,
    this.subject,
    this.body,
    this.validate = MailtoValidate.viaAssertions,
  }) : assert(() {
          if (validate == MailtoValidate.viaAssertions)
            Mailto.validateParameters(
              to: to,
              cc: cc,
              bcc: bcc,
              subject: subject,
              body: body,
            );
          return true;
        }());

  /// Specify whether you want to use the input validation provided by the
  /// package.
  ///
  /// By default, we use [MailtoValidate.viaAssertions] to make the development
  /// experience better for you: we try to make it easier for you to spot errors
  /// in your input.
  ///
  /// If you, for some reason, wish to turn this validation off, use
  /// [MailtoValidate.never].
  final MailtoValidate validate;

  @visibleForTesting
  static validateParameters({
    List<String> to,
    List<String> cc,
    List<String> bcc,
    String subject,
    String body,
  }) {
    if (to == null) throw ArgumentError.notNull('to');
    if (to.isEmpty)
      throw ArgumentError.value(
        to,
        'to',
        '"to" list must contain at least one element',
      );
    bool isEmpty(String e) => e.isEmpty;
    bool containsLineBreak(String e) => e.contains('\n');
    if (to.any(isEmpty))
      throw ArgumentError.value(
        to,
        'to',
        'elements in "to" list must not be empty',
      );
    if (to.any(containsLineBreak))
      throw ArgumentError.value(
        to,
        'to',
        'elements of the "to" list must not contain line breaks',
      );
    if (cc?.any(isEmpty) == true)
      throw ArgumentError.value(
        cc,
        'cc',
        'elements in "cc" list must not be empty. '
            'Use null if you want to leave the "cc" out from the mailto link, '
            'pass in null or leave it empty',
      );
    if (cc?.any(containsLineBreak) == true)
      throw ArgumentError.value(
        cc,
        'cc',
        'elements of the "cc" list must not contain line breaks',
      );
    if (bcc?.any(isEmpty) == true)
      throw ArgumentError.value(
        bcc,
        'bcc',
        'elements in "bcc" list must not be empty. '
            'Use null if you want to leave the "bcc" out from the mailto link, '
            'pass in null or leave it empty',
      );
    if (bcc?.any(containsLineBreak) == true)
      throw ArgumentError.value(
        bcc,
        'bcc',
        'elements of the "bcc" list must not contain line breaks',
      );
    if (subject?.contains('\n') == true)
      throw ArgumentError.value(
        subject,
        'subject',
        '"subject" must not contain line breaks',
      );
  }

  /// Main recipient(s) of your email
  ///
  /// Destination email addresses.
  ///
  /// * must not be null
  /// * list must not be empty
  /// * elements in the list must not be empty
  /// * elements in the list must not contain line-breaks
  final List<String> to;

  /// Recipient(s) of a copy of the email.
  ///
  /// CC stands for carbon copy. When you CC people on an email, the CC list is
  /// visible to all other recipients.
  ///
  /// * if the list is not null, the list must not be empty
  /// * elements in the list must not be empty
  /// * elements in the list must not contain line-breaks
  final List<String> cc;

  /// Recipient(s) of a secret copy of the email.
  ///
  /// BCC stands for blind carbon copy. When you BCC people on an email, the
  /// BCC list is not visible to other recipients.
  ///
  /// * if the list is not null, the list must not be empty
  /// * elements in the list must not be empty
  /// * elements in the list must not contain line-breaks
  final List<String> bcc;

  /// Subject of email.
  final String subject;

  /// Body of email.
  ///
  /// The content of the email.
  ///
  /// Please be aware that not all email clients are able to handle
  /// line-breaks in the body.
  final String body;

  /// Percent encoded value of the comma (',') character.
  ///
  /// ```dart
  /// Uri.encodeComponent(',') == _comma; // true
  /// ```
  static const String _comma = '%2C';

  String _encodeTo(String s) {
    final atSign = s.lastIndexOf('@');
    return Uri.encodeComponent(s.substring(0, atSign)) + s.substring(atSign);
  }

  @override
  String toString() {
    if (validate == MailtoValidate.enabled) {
      Mailto.validateParameters(
        to: to,
        cc: cc,
        bcc: bcc,
        subject: subject,
        body: body,
      );
    }
    final stringBuffer = StringBuffer('mailto:');
    // The "to" address list is required to include at least one address.
    stringBuffer.writeAll(to.map(_encodeTo), _comma);
    // We need this flag to know whether we should use & or ? when creating
    // the string.
    bool paramAdded = false;
    final m = {
      'subject': subject,
      'body': body,
      'cc': cc?.join(','),
      'bcc': bcc?.join(','),
    };
    for (var entry in m.entries) {
      // Do not add key-value pair where the value is missing or empty
      if (entry.value == null || entry.value.isEmpty) continue;
      // We don't need to encode the keys because all keys are under the
      // package's control currently and all of those keys are simple keys
      // without any special characters.
      // The RFC also mentions that the body should use '%0D%0A' for line-breaks
      // however, we didn't find any difference between '%0A' and '%0D%0A',
      // so we keep it at '%0A'.
      stringBuffer
        ..write(paramAdded ? '&' : '?')
        ..write(entry.key)
        ..write('=')
        ..write(Uri.encodeComponent(entry.value));
      paramAdded = true;
    }
    return '$stringBuffer';
  }
}
