import 'dart:io';

import 'package:mailto/mailto.dart';

String renderHtml(Mailto mailto) => '''
<html>
  <head>
    <title>mailto example</title>
  </head>
  <body>
    <a href="$mailto">Open mail client</a>
  </body>
</html>
''';

Future<void> main() async {
  final mailto = Mailto(
    to: [
      'example@example.com',
      'ejemplo@ejemplo.com',
    ],
    cc: [
      'percentage%100@example.com',
      'QuestionMark?address@example.com',
    ],
    bcc: [
      'Mike&family@example.org',
    ],
    subject: 'Let\'s drink a "café"! ☕️ 2+2=4 #coffeeAndMath',
    body:
        'Hello this if the first line!\n\nNew line with some special characters őúóüűáéèßáñ\nEmoji: 🤪💙👍',
  );

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

  print('Listening on http://localhost:${server.port}');

  await for (HttpRequest request in server) {
    print('received request!');
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write(renderHtml(mailto));
    await request.response.close();
  }
}
