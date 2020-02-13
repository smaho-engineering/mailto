# `mailto`

> Simple Dart package for creating mailto links in your Flutter apps

This package helps you build mailto links and use those mailto links to launch the phone's email client with certain fields pre-filled, while taking care of encoding every fields properly.

The `mailto` package:

* supports one or many `to`, `cc`, and `bcc` fields
* supports custom body and subject for the emails
* encodes every value for your correctly
* is blazingly fast 😜

[![smaho-engineering/mailto](https://img.shields.io/static/v1?label=smaho-engineering&message=mailto&style=flat-square&logo=flutter&logoWidth=30&color=FF8200&labelColor=08589c&labelWidth=30)](https://github.com/smaho-engineering/mailto) [![Build Status](https://travis-ci.org/smaho-engineering/mailto.svg?branch=master)](https://travis-ci.org/smaho-engineering/mailto)

## Important links

* [Read the source code and **star the repo!**](https://github.com/smaho-engineering/mailto)
* [Check package info on `pub.dev`](https://pub.dev/packages/mailto)
* [Open an issue](https://github.com/smaho-engineering/mailto/issues)
* [Read the docs](https://pub.dev/documentation/mailto/latest/)
* This Dart package is created by the [SMAHO development team](https://github.com/smaho-engineering).

## Usage

Most likely, you want to launch the email client on the phone with certain fields pre-filled.

```dart
import 'package:mailto/mailto.dart';
// Optional, but most likely what you want
import 'package:url_launcher/url_launcher.dart';

// Somewhere in your app
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

Use [`url_launcher`](https://pub.dev/packages/url_launcher) for launching the links you create with the `mailto` package.

## Contribute

### Tests

We use the [`test`](https://pub.dev/packages/test) package for writing and running tests.

**Run the test locally by `pub run test`.**


### Format

We use the [`dartfmt`](https://dart.dev/tools/dartfmt) tool to automatically format our code in a way that follows the Dart guidelines.

**Format your code by executing `dartfmt -w .`.**
