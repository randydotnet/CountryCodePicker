library country_code_picker;

import 'package:country_code_picker/celement.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:country_code_picker/selection_dialog.dart';
import 'package:flutter/material.dart';

export 'celement.dart';

class CountryCodePicker extends StatefulWidget {
  final Function(CElement) onChanged;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  CountryCodePicker(
      {this.onChanged,
      this.initialSelection,
      this.favorite,
      this.textStyle,
      this.padding});

  @override
  State<StatefulWidget> createState() {
    List<Map> jsonList = codes;

    List<CElement> elements = jsonList
        .map((s) => new CElement(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flag: s['flag'],
            ))
        .toList();
    return new _CountryCodePickerState(elements);
  }
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  CElement selectedItem;
  List<CElement> elements = [];
  List<CElement> favoriteElements = [];

  _CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) => new FlatButton(
        child: new Text(
          "${selectedItem.toString()}",
          style: widget.textStyle ?? Theme.of(context).textTheme.button,
        ),
        padding: widget.padding,
        onPressed: _showSelectionDialog,
      );

  @override
  initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhere(
                (f) => e.code == f.toUpperCase() || e.dialCode == f.toString(),
                orElse: () => null) !=
            null)
        .toList();
    super.initState();
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      child: new SelectionDialog(elements, favoriteElements),
    ).then((e) {
      if (e != null) {
        setState(() {
          selectedItem = e;
        });

        if (widget.onChanged != null) {
          widget.onChanged(e);
        }
      }
    });
  }
}
