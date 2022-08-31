// :snippet-start: modify-item
// ... other imports
// :remove-start:
import 'package:flutter/material.dart';
import 'package:flutter_todo/viewmodels/item_viewmodel.dart';
// :remove-end:
import 'package:flutter_todo/components/select_priority.dart'; // :emphasize:

// showModifyItemModal function
// :remove-start:
void showModifyItemModal(BuildContext context, ItemViewModel item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Wrap(children: [ModifyItemForm(item)]),
  );
}
// :remove-end:

class ModifyItemForm extends StatefulWidget {
  final ItemViewModel item;
  const ModifyItemForm(this.item, {Key? key}) : super(key: key);

  @override
  _ModifyItemFormState createState() => _ModifyItemFormState();
}

class _ModifyItemFormState extends State<ModifyItemForm> {
  final _formKey = GlobalKey<FormState>();
  late bool _isComplete;
  late String _summary;
  late int _priority; // :emphasize:

  @override
  void initState() {
    super.initState();
    _summary = widget.item.summary;
    _isComplete = widget.item.isComplete;
    _priority = widget.item.priority; // :emphasize:
  }

  @override
  Widget build(BuildContext context) {
    TextTheme myTextTheme = Theme.of(context).textTheme;
    final item = widget.item;

    // :emphasize-start:
    void updateItem() {
      item.update(
          summary: _summary, isComplete: _isComplete, priority: _priority);
    }
    // :emphasize-end:

    // deleteItem and handleItemRadioChange functions
    // :remove-start:
    void deleteItem() {
      item.delete();
    }

    void handleItemRadioChange(bool? value) {
      setState(() {
        _isComplete = value ?? false;
      });
    }
    // :remove-end:

    // :emphasize-start:
    void _setPriority(int priority) {
      setState(() {
        _priority = priority;
      });
    }
    // :emphasize-end:

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.only(
          top: 25,
          bottom: 25,
          left: 30,
          right: 30,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // ... Text and TextFormField widgets
                // :remove-start:
                Text(
                  'Update Your Item',
                  style: myTextTheme.headline6,
                ),
                TextFormField(
                  initialValue: _summary,
                  onChanged: (value) {
                    setState(() {
                      _summary = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                // :remove-end:
                SelectPriority(_priority, _setPriority), // :emphasize:
                // ... other widgets
                // :remove-start:
                Column(
                  children: <Widget>[
                    RadioListTile(
                      title: const Text('Complete'),
                      value: true,
                      onChanged: handleItemRadioChange,
                      groupValue: _isComplete,
                    ),
                    RadioListTile(
                      title: const Text('Incomplete'),
                      value: false,
                      onChanged: handleItemRadioChange,
                      groupValue: _isComplete,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            child: const Text('Cancel'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                            onPressed: () => Navigator.pop(context)),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            child: const Text('Delete'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              deleteItem();
                              Navigator.pop(context);
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          child: const Text('Update'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              updateItem();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // :remove-end:
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// :snippet-end:
