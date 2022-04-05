part of 'bloc.dart';

abstract class BaseBloc {
  late String _id;

  bool _isRegistered = false;
  bool disposed = false;

  BlocContainer? container;

  String getId() => _id;
  BuildContext context;

  String helloWord() {
    return "Hello world,my id - $_id";
  }

  @mustCallSuper
  BaseBloc({bool registerToContainer = false, required this.context}) {
    _id = base64Encode(DateTime.now().toString().codeUnits);
    _isRegistered = registerToContainer;
    if (registerToContainer) _registerToContainer(context);
  }

  @mustCallSuper
  void dispose() {
    disposed = true;
    if (_isRegistered) {
      container?.unregister(this);
    }
  }

  _registerToContainer(BuildContext context) {
    if (_isRegistered == true) {
      container = BlocContainer.of(context);
      container?.register(this);
    }
  }
}
