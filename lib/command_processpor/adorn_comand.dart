class AdornCommand {
  String commandName;
  String commandType;
  List<String> options;
  Future Function(List<String> args) operation;

  AdornCommand({
    required this.commandType,
    required this.commandName,
    required this.operation,
    this.options = const [],
  });
}
