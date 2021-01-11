# `mailto`

> Simple Dart package for creating mailto links in your Flutter and Dart apps

The `mailto` package helps you build mailto links and provides you with an idiomatic Dart interface that:

* supports one or many `to`, `cc`, and `bcc` fields
* supports custom body and subject for the emails
* encodes every value for your correctly
* is blazingly fast ⚡️😜

[![smaho-engineering/mailto](https://img.shields.io/static/v1?label=smaho-engineering&message=mailto&logo=flutter&logoWidth=30&color=FF8200&labelColor=08589c&labelWidth=30)](https://github.com/smaho-engineering)

[![Build Status](https://travis-ci.org/smaho-engineering/mailto.svg?branch=master)](https://travis-ci.org/smaho-engineering/mailto 'Check build status on TravisCI') [![Code coverage](https://img.shields.io/codecov/c/github/smaho-engineering/mailto.svg)](https://codecov.io/gh/smaho-engineering/mailto 'Check coverage info')

[![mailto](https://img.shields.io/pub/v/mailto?label=mailto&logo=data:image/png;base64,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)](https://pub.dev/packages/mailto 'See mailto package info on pub.dev')
[![GitHub Stars Count](https://img.shields.io/github/stars/smaho-engineering/mailto?logo=github)](https://github.com/smaho-engineering/mailto 'Star our repository on GitHub!')

## Important links

* [Read the source code and **star the repo!**](https://github.com/smaho-engineering/mailto)
* [Check package info on `pub.dev`](https://pub.dev/packages/mailto)
* [Open an issue](https://github.com/smaho-engineering/mailto/issues)
* [Read the docs](https://pub.dev/documentation/mailto/latest/)
* This Dart package is created by the [SMAHO development team](https://github.com/smaho-engineering)

## Usage

You may want to launch the email client on your user's phone with certain fields pre-filled.
For Flutter apps, it's recommended to use the [`url_launcher`](https://pub.dev/packages/url_launcher) package for launching the links you create with the `mailto` package.

```dart
import 'package:mailto/mailto.dart';
// For Flutter applications, you'll most likely want to use
// the url_launcher package.
import 'package:url_launcher/url_launcher.dart';

// ...somewhere in your Flutter app...
launchMailto() async {
  final mailtoLink = Mailto(
    to: ['to@example.com'],
    cc: ['cc1@example.com', 'cc2@example.com'],
    subject: 'mailto example subject',
    body: 'mailto example body',
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
}
```

### Validation

The package provides a simple validation function. 
You could use this function in an `assert` to catch issues in development mode.

The package doesn't validate automatically, so either use the validation function or make sure that the parameters you use are correct.

```dart
Mailto.validateParameters(
  // New lines are NOT supported in subject lines
  subject: 'new lines in subject \n FTW',
  // What does this even mean?
  cc: ['\n\n\n', null, ''],
);
```

## Known limitations of `mailto` URIs

I tested the package manually in Flutter apps on iOS and Android (Gmail, FastMail, Yahoo email client), and in the browser on macOS,
and the package has an extensive test suite that incorporates many examples from the [RFC 6068 - The 'mailto' URI Scheme](https://tools.ietf.org/html/rfc6068) document.

Unfortunately, each client handle mailto links differently: Gmail does not add line-breaks in the message `body`,
FastMail skips the `bcc`, Yahoo is not able to handle encoded values in `subject` and `body`, and these are only the three clients I tested.
The iOS email client seems to handle everything well, so 🎸🤘🎉.

The package might also not work if the resulting mailto links are extremely long. I don't know the exact character count where the links fail, but I'd try to keep things under 1000 characters.

**Important**: Make sure you understand these limitations before you decide to incorporate `mailto` links in your app:
letting users open their email clients with pre-filled values is a quick and easy way to let your users get in touch with you
with extremely little development effort. At the same time, you need to keep in mind that it's very unlikely
that these links are going to work consistently for all of your users.

**If you need something bullet-proof, this package is not the right tool for solving your problem, so please consider alternative solutions (e.g. Flutter forms and a working backend).**

In case you find potential improvements to the package, please create a pull request or let's discuss it in an issue.
I might not merge all pull requests, especially changes that improve things for one client, but makes it worse for others.
We consider the iOS mail app and Gmail on Android the two most important mail clients.

## Examples

You'll find runnable, great examples on the project's GitHub repository in the [**`/example` folder**](https://github.com/smaho-engineering/mailto/tree/master/example).

### Flutter example app

1. Clone the repository
1. Change directory to `cd example/flutter`
1. `flutter run` and wait for the app to start
1. You can fill out the forms with your own input or click the "Surprise me" button to see how your mail client handles tricky input

### HTTP server serving an HTML web page with a mailto link

The `mailto` package works in any Dart program: be it Flutter, AngularDart, or on the server.

```dart
import 'dart:io';

import 'package:mailto/mailto.dart';

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
  String renderHtml(Mailto mailto) => '''<html><head><title>mailto example</title></head><body><a href="$mailto">Open mail client</a></body></html>''';
  await for (HttpRequest request in server) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write(renderHtml(mailto));
    await request.response.close();
  }
}
```

1. Clone the repository
1. Change directory to `cd example/http_server`
1. Start HTTP server `dart main.dart`
1. Open your browser and visit `localhost:3000`
1. Click on the link
1. If you have an email client installed on your computer, this client will be opened when you click the link on the HTML page.

#### Screenshots

<img src="https://github.com/smaho-engineering/mailto/blob/master/assets/dart-server.png?raw=true" alt="mailto demo: Dart server HTML" width="500"/>

<img src="https://github.com/smaho-engineering/mailto/blob/master/assets/macos-client.png?raw=true" alt="mailto demo: MacOS email client" width="500"/>

