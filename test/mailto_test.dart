import 'package:mailto/mailto.dart';
import 'package:test/test.dart';

void _test(String description, Mailto builder, String expectedResult) {
  test(description, () {
    expect(builder.toString(), expectedResult);
  });
}

const _email = 'johndoe@example.com';

void main() {
  group(
    '$Mailto',
    () {
      _test(
        'Only "to" address is set',
        Mailto(to: [_email]),
        'mailto:$_email',
      );

      _test(
        'One-word "subject"',
        Mailto(
          to: [_email],
          subject: 'Word',
        ),
        'mailto:$_email?subject=Word',
      );

      _test(
        'Long "subject" with spaces',
        Mailto(
          to: [_email],
          subject: 'Hello World',
        ),
        'mailto:$_email?subject=Hello%20World',
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
        'Ampersand in "subject"',
        Mailto(
          to: [_email],
          subject: 'Amp & Sand',
        ),
        'mailto:$_email?subject=Amp%20%26%20Sand',
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
