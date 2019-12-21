import 'package:mailto/mailto.dart';

void main() {
  final to = ['to@example.com'];
  final cc = ['cc1@example.com', 'cc2@example.com'];
  final subject = 'mailto example subject';
  final body = 'mailto example body';

  final mailtoLink = Mailto(
    to: to,
    cc: cc,
    subject: subject,
    body: body,
  );

  print('If you were to write an email to ${to[0]} '
      'with a copy to ${cc.join(", ")} '
      'with subject $subject and body $body, '
      'you would use this mailto link: $mailtoLink');
}
