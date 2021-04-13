import 'package:flutter/cupertino.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MailtoExampleApp());

class MailtoExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: CupertinoColors.activeGreen,
          ),
        ),
      ),
      home: MailtoDemo(),
    );
  }
}

const Color white = Color(0xFFFFFFFF);
const EdgeInsets textFieldPadding = EdgeInsets.all(16);
const EdgeInsets iconPadding = EdgeInsets.fromLTRB(12, 0, 12, 0);

class MailtoDemo extends StatefulWidget {
  @override
  _MailtoDemoState createState() => _MailtoDemoState();
}

class _MailtoDemoState extends State<MailtoDemo> {
  List<String> to = [];
  List<String> cc = [];
  List<String> bcc = [];
  String subject = '';
  String body = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: white,
        middle: Text(
          'mailto',
        ),
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: CupertinoButton(
              color: Color(0xFF8E44AD),
              child: Text('Suprise me!'),
              onPressed: () async {
                final url = Mailto(
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
                ).toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: MailClientOpenErrorDialog(url: url).build,
                  );
                }
              },
            ),
          ),
          EmailsContainer(
            onChanged: (v) => to = v,
            icon: CupertinoIcons.person_solid,
            title: 'to',
            placeholder: 'Recipient',
          ),
          EmailsContainer(
            onChanged: (v) => cc = v,
            icon: CupertinoIcons.group_solid,
            title: 'cc',
            placeholder: 'Carbon-copy',
          ),
          EmailsContainer(
            onChanged: (v) => bcc = v,
            icon: CupertinoIcons.group,
            title: 'bcc',
            placeholder: 'Blind Carbon-copy',
          ),
          SubjectTextField(
            onChanged: (v) => subject = v,
          ),
          BodyTextField(
            onChanged: (v) => body = v,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 12,
            ),
            child: CupertinoButton.filled(
              child: Text('Open Mail Client'),
              onPressed: () async {
                final url = Mailto(
                  to: to,
                  cc: cc,
                  bcc: bcc,
                  subject: subject,
                  body: body,
                ).toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: MailClientOpenErrorDialog(url: url).build,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MailClientOpenErrorDialog extends StatelessWidget {
  final String url;

  const MailClientOpenErrorDialog({Key? key, required this.url})
      : assert(url != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Launch Error'),
      content: Text('We could not launch the following url:\n$url'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class BodyTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const BodyTextField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _BodyTextFieldState createState() => _BodyTextFieldState();
}

class _BodyTextFieldState extends State<BodyTextField> {
  final TextEditingController _controller = TextEditingController();

  bool isEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SectionHeading(
          leadingIcon: CupertinoIcons.book,
          title: 'body',
          trailingIcon:
              isEnabled ? CupertinoIcons.delete : CupertinoIcons.add_circled,
          onPressed: () {
            setState(() => isEnabled = !isEnabled);
            _controller.text = '';
            if (isEnabled) {
              widget.onChanged(_controller.text);
            }
          },
        ),
        if (isEnabled)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: CupertinoTextField(
              controller: _controller,
              padding: textFieldPadding,
              minLines: 4,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              placeholder: 'Body of the email',
              onChanged: widget.onChanged,
            ),
          ),
      ],
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final IconData trailingIcon;

  const SectionHeading({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.leadingIcon,
    required this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: iconPadding,
                child: Icon(leadingIcon),
              ),
              LargeText(title),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CupertinoButton(
              child: Icon(trailingIcon),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SubjectTextField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SubjectTextFieldState createState() => _SubjectTextFieldState();
}

class _SubjectTextFieldState extends State<SubjectTextField> {
  final TextEditingController _controller = TextEditingController();

  bool isEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SectionHeading(
          leadingIcon: CupertinoIcons.mail,
          title: 'subject',
          trailingIcon:
              isEnabled ? CupertinoIcons.delete : CupertinoIcons.add_circled,
          onPressed: () {
            setState(() => isEnabled = !isEnabled);
            _controller.text = '';
            if (isEnabled) {
              widget.onChanged(_controller.text);
            }
          },
        ),
        if (isEnabled)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: CupertinoTextField(
              controller: _controller,
              padding: textFieldPadding,
              textCapitalization: TextCapitalization.words,
              placeholder: 'Subject of the email',
              onChanged: widget.onChanged,
            ),
          ),
      ],
    );
  }
}

class LargeText extends StatelessWidget {
  final String data;

  const LargeText(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        data,
        style: CupertinoTheme.of(context)
            .textTheme
            .navLargeTitleTextStyle
            .copyWith(color: CupertinoColors.black),
      ),
    );
  }
}

class EmailsContainer extends StatefulWidget {
  const EmailsContainer({
    Key? key,
    required this.title,
    required this.icon,
    required this.onChanged,
    required this.placeholder,
  }) : super(key: key);

  final String title;
  final String placeholder;
  final IconData icon;
  final ValueChanged<List<String>> onChanged;

  @override
  _EmailsContainerState createState() => _EmailsContainerState();
}

class _EmailsContainerState extends State<EmailsContainer> {
  final List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SectionHeading(
          leadingIcon: widget.icon,
          trailingIcon: CupertinoIcons.plus_circled,
          title: widget.title,
          onPressed: () {
            setState(() {
              _controllers.add(TextEditingController(text: ''));
            });
            callOnChanged();
          },
        ),
        ...buildTextFields(),
      ],
    );
  }

  void callOnChanged() {
    widget.onChanged(_controllers.map((c) => c.text.trim()).toList());
  }

  void removeController(int index) {
    assert(index >= 0);
    assert(index < _controllers.length);
    setState(() => _controllers.removeAt(index));
    callOnChanged();
  }

  List<Widget> buildTextFields() {
    final widgets = <Widget>[];
    _controllers.asMap().forEach((index, controller) {
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: CupertinoTextField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          padding: textFieldPadding,
          suffix: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => removeController(index),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Icon(CupertinoIcons.minus_circled),
            ),
          ),
          textCapitalization: TextCapitalization.none,
          placeholder: '${widget.placeholder} ${index + 1}',
          onChanged: (_) => callOnChanged(),
        ),
      ));
    });
    return widgets;
  }
}
