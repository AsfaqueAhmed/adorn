part of 'stubs.dart';

String pageStub(String pageName) => '''
import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';

class ${ReCase(pageName).pascalCase} extends AdornStatefulWidget {

  static const String routeName = "$pageName";
  
  const ${ReCase(pageName).pascalCase}({Key? key}) : super(key: key);

  @override
  _${ReCase(pageName).pascalCase}State createState() => _${ReCase(pageName).pascalCase}State();
}

class _${ReCase(pageName).pascalCase}State extends AdornState<${ReCase(pageName).pascalCase}> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';

String pageStubWithController(String pageName) => '''
import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';
import '${pageName}_controller.dart';

class ${ReCase(pageName).pascalCase} extends AdornStatefulWidget {

  static const String routeName = "$pageName";
  
  const ${ReCase(pageName).pascalCase}({Key? key}) : super(key: key);

  @override
  _${ReCase(pageName).pascalCase}State createState() => _${ReCase(pageName).pascalCase}State();
}

class _${ReCase(pageName).pascalCase}State extends AdornState<${ReCase(pageName).pascalCase}> with ${ReCase(pageName).pascalCase}PageController{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';

String pageStubWithBloc(String pageName) => '''
import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';
import '../../bloc/${pageName}_bloc.dart';
import 'package:adorn/base/bloc/bloc.dart';

class ${ReCase(pageName).pascalCase} extends AdornStatefulWidget {

  static const String routeName = "$pageName";
  
  const ${ReCase(pageName).pascalCase}({Key? key}) : super(key: key);

  @override
  _${ReCase(pageName).pascalCase}State createState() => _${ReCase(pageName).pascalCase}State();
}

class _${ReCase(pageName).pascalCase}State extends AdornState<${ReCase(pageName).pascalCase}> {
  late ${ReCase(pageName).pascalCase}Bloc bloc;

  @override
  void initState() {
    bloc = ${ReCase(pageName).pascalCase}Bloc(context: context, registerToContainer: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<${ReCase(pageName).pascalCase}Bloc>(
      bloc: bloc,
      child: Container(),
    );
  }
}
''';

String pageStubWithControllerAndBloc(String pageName) => '''
import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';
import '../../bloc/${pageName}_bloc.dart';
import 'package:adorn/base/bloc/bloc.dart';
import '${pageName}_controller.dart';

class ${ReCase(pageName).pascalCase} extends AdornStatefulWidget {

  static const String routeName = "$pageName";
  
  const ${ReCase(pageName).pascalCase}({Key? key}) : super(key: key);

  @override
  _${ReCase(pageName).pascalCase}State createState() => _${ReCase(pageName).pascalCase}State();
}

class _${ReCase(pageName).pascalCase}State extends AdornState<${ReCase(pageName).pascalCase}> with ${ReCase(pageName).pascalCase}PageController{
  
  late ${ReCase(pageName).pascalCase}Bloc bloc;

  @override
  void initState() {
    bloc = ${ReCase(pageName).pascalCase}Bloc(context: context, registerToContainer: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<${ReCase(pageName).pascalCase}Bloc>(
      bloc: bloc,
      child: Container(),
    );
  }
}
''';

String pageControllerStub(String pageName) => '''
import 'package:adorn/base/widget/adorn_state.dart';
import '$pageName.dart';

mixin ${ReCase(pageName).pascalCase}PageController on AdornState<${ReCase(pageName).pascalCase}>{

}''';
