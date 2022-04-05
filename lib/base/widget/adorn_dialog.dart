import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';

class AdornDialog extends AdornStatefulWidget {
  final String? title;
  final String? content;
  final List<AdornDialogButton>? buttons;
  final AdornDialogType type;
  final Color titleColor;

  const AdornDialog._({
    this.title,
    this.content,
    this.buttons,
    this.type = AdornDialogType.general,
    this.titleColor = Colors.blue,
    Key? key,
  }) : super(key: key);

  @override
  _AdornDialogState createState() => _AdornDialogState();

  static showDialog({
    required BuildContext context,
    required String? title,
    required String? content,
    List<AdornDialogButton>? buttons,
    AdornDialogType? type = AdornDialogType.general,
    bool userAnimation = false,
  }) {
    Color color = type == AdornDialogType.general
        ? Colors.blue
        : type == AdornDialogType.error
        ? Colors.red
        : type == AdornDialogType.warning
        ? Colors.orangeAccent
        : type == AdornDialogType.success
        ? Colors.green
        : Colors.blue;

    return Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, ani1, ani2) {
            return AnimatedBuilder(
              animation: ani1,
              builder: (context, child) {
                return Material(
                  color: Color.lerp(
                      Colors.transparent, Colors.black26, ani1.value),
                  child: child,
                );
              },
              child: Center(
                child: Align(
                  heightFactor: userAnimation ? ani1.value : 1,
                  child: AdornDialog._(
                    type: type ?? AdornDialogType.general,
                    title: title,
                    titleColor: color,
                    content: content,
                    buttons: buttons,
                  ),
                ),
              ),
            );
          },
        ));
  }
}

class _AdornDialogState extends AdornState<AdornDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _dialogBody();
  }

  Widget _dialogBody() {
    return Container(
      decoration: BoxDecoration(color: currentTheme.backgroundColor,
      ),
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.title == null
              ? const SizedBox()
              : Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.titleColor,
                  width: 4,
                ),
              ),
            ),
            child: Text(
              widget.title!,
              style: textTheme.bodyText1?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.titleColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.title!,
            style: textTheme.bodyText1,
          ),
          const SizedBox(height: 16),
          widget.buttons == null || widget.buttons!.isEmpty
              ? Row(
            children: [
              Expanded(child: AdornDialogButton.close(onTap: () {
                Navigator.pop(context);
              }),)
            ],
          )
              : Row(
            children:
            widget.buttons!.map((e) => Expanded(child: e)).toList(),
          )
        ],
      ),
    );
  }
}

enum AdornDialogType { general, error, success, warning }

class AdornDialogButton extends StatefulWidget {
  final String label;
  final TextStyle labelStyle;
  final Function() onTap;

  const AdornDialogButton({
    Key? key,
    required this.label,
    required this.labelStyle,
    required this.onTap,
  }) : super(key: key);

  const AdornDialogButton.ok({
    Key? key,
    required this.onTap,
  })
      : labelStyle = const TextStyle(
    inherit: true,
    color: Colors.green,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
        label = "Ok",
        super(key: key);

  const AdornDialogButton.cancel({
    Key? key,
    required this.onTap,
  })
      : labelStyle = const TextStyle(
    inherit: true,
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
        label = "Cancel",
        super(key: key);

  const AdornDialogButton.close({
    Key? key,
    required this.onTap,
  })
      : labelStyle = const TextStyle(
    inherit: true,
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
        label = "Close",
        super(key: key);

  @override
  State<AdornDialogButton> createState() => _AdornDialogButtonState();
}

class _AdornDialogButtonState extends State<AdornDialogButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: RawMaterialButton(
        onPressed: widget.onTap,
        child: Row(
          children: [
            Expanded(
                child: Center(
                  child: Text(
                    widget.label,
                    style: widget.labelStyle,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
