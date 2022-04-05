import 'package:flutter/material.dart';
import 'package:adorn/base/widget/adorn_statefull_widget.dart';
import 'package:adorn/base/widget/adorn_state.dart';

class AdornItemPicker<T> extends AdornStatefulWidget {
  final String title;
  final T selectedItem;
  final List<T> items;
  final Widget Function(T item, bool selected) itemBuilder;
  final String Function(T item) getTitle;
  final bool Function(T item, T pickedItem)? checkIfSelected;
  final bool enableSearch;

  const AdornItemPicker({
    Key? key,
    required this.title,
    required this.selectedItem,
    required this.items,
    required this.itemBuilder,
    required this.getTitle,
    this.checkIfSelected,
    this.enableSearch = false,
  }) : super(key: key);

  @override
  _AdornItemPickerState<T> createState() => _AdornItemPickerState<T>();

  static Future<Type?> show<Type>(
    context, {
    required String title,
    required Type selectedItem,
    required List<Type> items,
    required Widget Function(Type item, bool selected) itemBuilder,
    required String Function(Type item) getTitle,
    bool Function(Type item, Type pickedItem)? checkIfSelected,
    bool enableSearch = false,
  }) {
    var ui = AdornItemPicker<Type>(
      title: title,
      selectedItem: selectedItem,
      items: items,
      itemBuilder: itemBuilder,
      getTitle: getTitle,
      checkIfSelected: checkIfSelected,
      enableSearch: enableSearch,
    );
    if (!enableSearch) {
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
          context: context,
          builder: (context) {
            return ui;
          });
    }
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              child: ui,
            ),
          );
        });
  }
}

class _AdornItemPickerState<Type> extends AdornState<AdornItemPicker<Type>> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderSide: BorderSide(color: currentTheme.textColor2!),
        borderRadius: BorderRadius.circular(8));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffE0E0E0), width: 1))),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close))
            ],
          ),
        ),
        widget.enableSearch
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  maxLines: 1,
                  controller: textEditingController,
                  cursorColor: currentTheme.textColor2,
                  style: textTheme.bodyText1!.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    border: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    disabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    hintText: "Search",
                    hintStyle: TextStyle(color: currentTheme.textColor2),
                  ),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: textEditingController,
              builder: (context, value, child) {
                var items = widget.items
                    .where((element) => widget.getTitle!(element)
                        .toLowerCase()
                        .contains(textEditingController.text.toLowerCase()))
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: widget.itemBuilder(
                            item,
                            widget.checkIfSelected == null
                                ? item == widget.selectedItem
                                : widget.checkIfSelected!(
                                    item, widget.selectedItem)),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
