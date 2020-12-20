# `mailto` changelog

### `1.1.0`

* `to` values were made optional [`mailto #4`](https://github.com/smaho-engineering/mailto/issues/4)
* removed the `validate` argument from `Mailto`. You may still validate paramaters using the `Mailto.validateParameters` static function.

### `1.0.0`

* Correctly encode trickier "to" arguments from the RFC linked in the README
* Validate input in constructor and throw `ArgumentError` if something is incorrect
* Make validation optional by setting the `validate` argument to `MailtoValidate.never`
* Clarify in README the limitations of mailto links
* Add server example so it's easy to test on desktop/browser
* Add screenshots about example Flutter app and server
* README improvements
* Fix pub.dev pub points

### `0.1.4`

Improve README

### `0.1.3`

Write README and Flutter example app

### `0.1.2`

Add the `meta` package as dependency

### `0.1.1`

Add changelog and example command-line script

### `0.1.0`

Initial version of the `mailto` package
