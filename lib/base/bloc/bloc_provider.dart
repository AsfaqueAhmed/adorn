part of 'bloc.dart';

class BlocProvider<Bloc extends BaseBloc> extends StatefulWidget {
  final Bloc bloc;
  final Widget child;

  const BlocProvider({
    Key? key,
    required this.bloc,
    required this.child,
  }) : super(key: key);

  static Bloc? of<Bloc extends BaseBloc>(BuildContext context) {
    final BlocProvider<Bloc>? result =
        context.findAncestorWidgetOfExactType<BlocProvider<Bloc>>();
    assert(result != null,
        'No BlocProvider<${Bloc.runtimeType}> found in context');
    return result?.bloc;
  }

  @override
  _BlocProviderState createState() => _BlocProviderState<Bloc>();
}

class _BlocProviderState<Bloc extends BaseBloc>
    extends State<BlocProvider<Bloc>> {
  @override
  void dispose() {
    if (!widget.bloc.disposed) {
      widget.bloc.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
