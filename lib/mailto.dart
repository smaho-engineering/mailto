import 'package:meta/meta.dart';

/// [Mailto] helps you create email ("mailto") links.
///
/// The class takes care of all the necessary encoding.
///
/// You can use the `url_launcher` package for launching the
/// URL that the [Mailto] class's [toString] method returns.
/// It will open the default email client on the smart phone,
/// with prefilled [to], [cc], [bcc] recipient list, [subject], and [body]
/// (content of the email).
///
/// The user can still decide not to send an email or edit any of the
/// fields.
class Mailto {
  Mailto({
    @required this.to,
    this.cc,
    this.bcc,
    this.subject,
    this.body,
  }) : assert(
          to != null && to.isNotEmpty && to.every((t) => t.isNotEmpty),
          'Destination email address "to" is a required parameter and all addresses must not be empty.',
        );

  /// Main recipient(s) of your email
  ///
  /// Destination email addresses.
  final List<String> to;

  /// Recipient(s) of a copy of the email.
  ///
  /// CC stands for carbon copy. When you CC people on an email, the CC list is
  /// visible to all other recipients.
  final List<String> cc;

  /// Recipient(s) of a secret copy of the email.
  ///
  /// BCC stands for blind carbon copy. When you BCC people on an email, the
  /// BCC list is not visible to other recipients.
  final List<String> bcc;

  /// Subject of email.
  final String subject;

  /// Body of email.
  ///
  /// The content of the email.
  final String body;

  StringBuffer _query(StringBuffer sb) {
    final m = {
      'subject': subject,
      'body': body,
      'cc': cc?.join(','),
      'bcc': bcc?.join(','),
    };
    var paramAdded = false;
    for (var e in m.entries) {
      // Do not add key-value pair where the value is missing or empty
      if (e.value == null || e.value.isEmpty) continue;
      // We don't need to encode the keys as all keys are under the package's
      // control and all of them are simple keys without any special characters.
      sb
        ..write(paramAdded ? '&' : '?')
        ..write(e.key)
        ..write('=')
        ..write(Uri.encodeComponent(e.value));
      paramAdded = true;
    }
    return sb;
  }

  StringBuffer _recipients(StringBuffer sb) => sb..writeAll(to, '%2C');

  @override
  String toString() => '${_query(_recipients(StringBuffer('mailto:')))}';
}
