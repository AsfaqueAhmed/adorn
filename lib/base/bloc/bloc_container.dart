part of 'bloc.dart';

class BlocContainer extends StatefulWidget {
  final List<BaseBloc> registeredBlocs;
  final Widget child;

  BlocContainer({
    Key? key,
    required this.child,
    this.registeredBlocs = const <BaseBloc>[],
  }) : super(key: key);

  static BlocContainer of(BuildContext context) {
    final BlocContainer? result =
    context.findAncestorWidgetOfExactType<BlocContainer>();
    assert(result != null, 'No BlocContainer found in context');
    return result!;
  }

  register(BaseBloc bloc) {
    assert(!registeredBlocs.any((element) => element._id == bloc._id),
    "This bloc is already registered");
    if (!registeredBlocs.any((element) => element._id == bloc._id)) {
      registeredBlocs.insert(0, bloc);
    }
  }

  unregister(BaseBloc bloc) {
    registeredBlocs.removeWhere(
          (element) => element._id == bloc._id,
    );
  }

  Bloc? getBloc<Bloc extends BaseBloc>() {
    var list = registeredBlocs.where((element) => element is Bloc).toList();
    return list.isEmpty ? null : list[0] as Bloc;
  }

  closeAllBloc() {
    for (BaseBloc element in registeredBlocs) {
      element.dispose();
    }
  }

  @override
  _BlocContainerState createState() => _BlocContainerState();
}

class _BlocContainerState extends State<BlocContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
