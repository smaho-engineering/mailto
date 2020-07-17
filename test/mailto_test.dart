import 'package:mailto/mailto.dart';
import 'package:test/test.dart';

void _test(String description, Mailto builder, String result) {
  test(description, () {
    expect('$builder', result);
  });
}

const _email = 'johndoe@example.com';

void main() {
  group('$Mailto', () {
    group('validate', () {
      Mailto invalidUsage(MailtoValidate validate) {
        if (validate == null) return Mailto(to: null);
        return Mailto(to: null, validate: validate);
      }

      test('defaults to assert mode ${MailtoValidate.viaAssertions}', () {
        expect(() {
          invalidUsage(null);
        }, throwsA(isA<ArgumentError>()));
      });

      test('via assertions with ${MailtoValidate.viaAssertions}', () {
        expect(() {
          invalidUsage(MailtoValidate.viaAssertions);
        }, throwsA(isA<ArgumentError>()));
      });

      test('is skipped with ${MailtoValidate.never}', () {
        expect(() {
          invalidUsage(MailtoValidate.never);
        }, isNot(throwsA(isA<ArgumentError>())));
      });

      test('upon toString with ${MailtoValidate.enabled}', () {
        Mailto mailto;
        expect(() {
          mailto = invalidUsage(MailtoValidate.enabled);
        }, isNot(throwsA(isA<ArgumentError>())));
        expect(() {
          final _ = '$mailto';
        }, throwsA(isA<ArgumentError>()));
      });
    });

    group('validateInput', () {
      group('"to"', () {
        test('must not be null', () {
          expect(
            () => Mailto.validateParameters(to: null),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('must not be empty', () {
          expect(
            () => Mailto.validateParameters(to: []),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('elements in "to" list must not be empty', () {
          expect(
            () => Mailto.validateParameters(to: ['']),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('elements of the "to" list must not contain line breaks', () {
          expect(
            () => Mailto.validateParameters(to: ['new line\nshould throw']),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('valid', () {
          expect(
            () => Mailto.validateParameters(to: ['example@example.com']),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });
      });

      group('"cc"', () {
        const to = ['example@example.com'];
        test('may be null', () {
          expect(
            () => Mailto.validateParameters(to: to, cc: null),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });

        test('may be empty list', () {
          expect(
            () => Mailto.validateParameters(to: to, cc: []),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });

        test('elements in "cc" list must not be empty', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              cc: ['example2@example.com', ''],
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('elements of the "cc" list must not contain line breaks', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              cc: ['something\n@example.com'],
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('valid "cc"', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              cc: ['cc@example.com'],
            ),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });
      });

      group('"bcc"', () {
        const to = ['example@example.com'];
        test('may be null', () {
          expect(
            () => Mailto.validateParameters(to: to, bcc: null),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });

        test('may be empty list', () {
          expect(
            () => Mailto.validateParameters(to: to, bcc: []),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });

        test('elements in "bcc" list must not be empty', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              bcc: ['example2@example.com', ''],
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('elements of the "bcc" list must not contain line breaks', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              bcc: ['something\n@example.com'],
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('valid "bcc"', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              bcc: ['cc@example.com'],
            ),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });
      });

      group('"subject"', () {
        const to = ['example@example.com'];
        test('may be null', () {
          expect(
            () => Mailto.validateParameters(to: to, subject: null),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });

        test('must not contain line breaks', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              subject: 'Subject example\nwith new lines',
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('valid "subject"', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              subject: 'Valid subject',
            ),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });
      });

      group('"body"', () {
        const to = ['example@example.com'];
        test('may be null', () {
          expect(
            () => Mailto.validateParameters(to: to, body: null),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });

        test('may contain line breaks', () {
          expect(
            () => Mailto.validateParameters(
              to: to,
              body: 'Body example\nwith new lines',
            ),
            isNot(throwsA(isA<ArgumentError>())),
          );
        });
      });
    });

    group('"to"', () {
      void _testTo(String description, List<String> to, String result) {
        _test(description, Mailto(to: to), result);
      }

      _testTo(
        'contains one simple email',
        ['example@example.com'],
        'mailto:example@example.com',
      );

      _testTo(
        'contains two simple emails',
        ['example@example.com', 'ejemplo@ejemplo.es'],
        'mailto:example@example.com%2Cejemplo@ejemplo.es',
      );

      // https://tools.ietf.org/html/rfc6068#section-6.1
      _testTo(
        'address contains percentage (%) sign',
        ['gorby%kremvax@example.com'],
        'mailto:gorby%25kremvax@example.com',
      );

      // https://tools.ietf.org/html/rfc6068#section-6.1
      _testTo(
        'address contains question mark (?) sign',
        ['unlikely?address@example.com'],
        'mailto:unlikely%3Faddress@example.com',
      );

      // https://tools.ietf.org/html/rfc6068#section-6.1
      _testTo(
        'address contains ampersand (&) sign',
        ['Mike&family@example.org'],
        'mailto:Mike%26family@example.org',
      );

      // https://tools.ietf.org/html/rfc6068#section-6.2
      _testTo(
        'complicated email address 1',
        ['"not@me"@example.com'],
        'mailto:%22not%40me%22@example.com',
      );

      // https://tools.ietf.org/html/rfc6068#section-6.2
      _testTo(
        'complicated email address 2',
        [r'"oh\\no"@example.org'],
        'mailto:%22oh%5C%5Cno%22@example.org',
      );

      // https://tools.ietf.org/html/rfc6068#section-6.2
      _testTo(
        'complicated email address 3',
        [r'''"\\\"it's\ ugly\\\""@example.org'''],
        '''mailto:%22%5C%5C%5C%22it's%5C%20ugly%5C%5C%5C%22%22@example.org''',
      );
    });

    group('"subject"', () {
      const email = 'subject@example.com';
      const to = [email];

      void _testSubject(String description, String subject, String result) {
        _test(description, Mailto(to: to, subject: subject), result);
      }

      _testSubject(
        'is one word',
        'Word',
        'mailto:subject@example.com?subject=Word',
      );

      _testSubject(
        'is multiple words',
        'Multiple words subject',
        'mailto:subject@example.com?subject=Multiple%20words%20subject',
      );

      _testSubject(
        'contains & ampersand',
        'Ampers & Sands Co.',
        'mailto:subject@example.com?subject=Ampers%20%26%20Sands%20Co.',
      );

      _testSubject(
        'contains + plus',
        '2+2',
        'mailto:subject@example.com?subject=2%2B2',
      );

      _testSubject(
        'contains = equals sign',
        '=3',
        'mailto:subject@example.com?subject=%3D3',
      );
    });
  });

  group(
    '$Mailto legacy tests',
    () {
      _test(
        'Only "to" address is set',
        Mailto(to: [_email]),
        'mailto:$_email',
      );

      _test(
        'Multiple to addresses',
        Mailto(
          to: [_email, 'vince@example.com'],
          subject: 'Hello Multiple',
          body: 'Mutliple to addresses',
        ),
        'mailto:$_email%2Cvince@example.com?subject=Hello%20Multiple&body=Mutliple%20to%20addresses',
      );

      _test(
        'Spaces, commas, and new lines in the "body"',
        Mailto(
          to: [_email],
          subject: 'Lorem Ipsum',
          body:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
        ),
        'mailto:$_email?subject=Lorem%20Ipsum&body=Lorem%20ipsum%20dolor%20sit%20amet%2C%20consectetur%20adipiscing%20elit%2C%20sed%20do%20eiusmod%20tempor%20incididunt%20ut%20labore%20et%20dolore%20magna%20aliqua.%0AUt%20enim%20ad%20minim%20veniam%2C%20quis%20nostrud%20exercitation%20ullamco%20laboris%20nisi%20ut%20aliquip%20ex%20ea%20commodo%20consequat.',
      );

      _test(
        'One address in "cc"',
        Mailto(
          to: [_email],
          subject: 'Multiple CCs',
          body: 'Multiple CC body',
          cc: [
            'vince@example.com',
          ],
        ),
        'mailto:$_email?subject=Multiple%20CCs&body=Multiple%20CC%20body&cc=vince%40example.com',
      );

      _test(
        'Multiple "cc" addresses are joined as encoded commas',
        Mailto(
          to: [_email],
          subject: 'Multiple CCs',
          body: 'Multiple CC body',
          cc: [
            'vince@example.com',
            'vicente@ejemplo.es',
          ],
        ),
        'mailto:$_email?subject=Multiple%20CCs&body=Multiple%20CC%20body&cc=vince%40example.com%2Cvicente%40ejemplo.es',
      );

      _test(
        'Empty "cc" list is skipped',
        Mailto(
          to: [_email],
          subject: 'EmptyCC',
          body: 'EmptyCCBody',
          cc: [],
        ),
        'mailto:$_email?subject=EmptyCC&body=EmptyCCBody',
      );

      _test(
        'Everything is set',
        Mailto(
          to: [_email],
          subject: 'cR@zY 3#4mPL3 with empty b0dy',
          body: '',
          cc: [
            'vince@example.com',
            'vicente@ejemplo.es',
          ],
          bcc: [
            'secret@example.com',
          ],
        ),
        'mailto:$_email?subject=cR%40zY%203%234mPL3%20with%20empty%20b0dy&cc=vince%40example.com%2Cvicente%40ejemplo.es&bcc=secret%40example.com',
      );
    },
  );
}
