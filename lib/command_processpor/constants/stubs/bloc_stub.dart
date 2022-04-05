part of 'stubs.dart';

String blocStub(String blocName) => '''
import 'package:adorn/base/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class ${ReCase(blocName).pascalCase}Bloc extends BaseBloc {
  ${ReCase(blocName).pascalCase}Bloc({required BuildContext context, required bool registerToContainer})
      : super(registerToContainer: registerToContainer, context: context);
}
''';
