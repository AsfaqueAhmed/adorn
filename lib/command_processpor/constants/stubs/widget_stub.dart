part of 'stubs.dart';

String widgetStub(String widgetName) => '''
import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';

class ${ReCase(widgetName).pascalCase} extends AdornStatefulWidget {
  const ${ReCase(widgetName).pascalCase}({Key? key}) : super(key: key);

  @override
  _${ReCase(widgetName).pascalCase}State createState() => _${ReCase(widgetName).pascalCase}State();
}

class _${ReCase(widgetName).pascalCase}State extends AdornState<${ReCase(widgetName).pascalCase}> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';

String widgetStubWithController(String widgetName) => '''
import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';
import '${widgetName}_widget_controller.dart';

class ${ReCase(widgetName).pascalCase} extends AdornStatefulWidget {
  const ${ReCase(widgetName).pascalCase}({Key? key}) : super(key: key);

  @override
  _${ReCase(widgetName).pascalCase}State createState() => _${ReCase(widgetName).pascalCase}State();
}

class _${ReCase(widgetName).pascalCase}State extends AdornState<${ReCase(widgetName).pascalCase}> with ${ReCase(widgetName).pascalCase}WidgetController{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';

String widgetControllerStub(String widgetName) => '''
import 'package:adorn/base/widget/adorn_state.dart';
import '${widgetName}_widget.dart';

mixin ${ReCase(widgetName).pascalCase}WidgetController on AdornState<${ReCase(widgetName).pascalCase}>{

}''';
