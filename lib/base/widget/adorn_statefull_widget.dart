import 'package:flutter/cupertino.dart';

/// StatefulWidget's include a [BaseController] to access from your child state.
abstract class AdornStatefulWidget extends StatefulWidget {
  const AdornStatefulWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

  String getRouteName() => this.runtimeType.toString();
}
