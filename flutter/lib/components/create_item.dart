// :snippet-start: create-item
// :remove-start:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:flutter_todo/realm/app_services.dart';
// :remove-end:
// ... other imports
import 'package:flutter_todo/viewmodels/item_viewmodel.dart';
import 'package:flutter_todo/components/select_priority.dart'; // :emphasize:

// ... CreateItem widget
// :remove-start:
class CreateItem extends StatelessWidget {
  const CreateItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handlePressed() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => Wrap(children: const [_CreateItemFormWrapper()]),
      );
    }

    return FloatingActionButton(
      onPressed: handlePressed,
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }
}
// :remove-end:

// _CreateItemFormWrapper widget
// :remove-start:
class _CreateItemFormWrapper extends StatelessWidget {
  const _CreateItemFormWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            color: Colors.grey.shade100,
            padding:
                const EdgeInsets.only(top: 25, bottom: 25, left: 50, right: 50),
            child: const Center(
              child: CreateItemForm(),
            )));
  }
}
// :remove-end:

class CreateItemForm extends StatefulWidget {
  const CreateItemForm({Key? key}) : super(key: key);

  @override
  _CreateItemFormState createState() => _CreateItemFormState();
}

class _CreateItemFormState extends State<CreateItemForm> {
  int _priority = PriorityLevel.low; // :emphasize:
  final _formKey = GlobalKey<FormState>();
  var taskEditingController = TextEditingController();

  // :emphasize-start:
  void _setPriority(int priority) {
    setState(() {
      _priority = priority;
    });
  }
  // :emphasize-end:

  @override
  Widget build(BuildContext context) {
    TextTheme myTextTheme = Theme.of(context).textTheme;
    final currentUser = Provider.of<AppServices>(context).currentUser;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ... Text and TextFormField widgets
          // :remove-start:
          Text(
            'Create a New Item',
            style: myTextTheme.headline6,
          ),
          TextFormField(
            controller: taskEditingController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          // :remove-end:
          SelectPriority(_priority, _setPriority), // :emphasize:
          // .. other widgets
          // :remove-start:
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
                // :remove-end:
                // Set priority when creating an Item
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Consumer<Realm>(
                    builder: (context, realm, child) {
                      return ElevatedButton(
                        child: const Text('Create'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final summary = taskEditingController.text;
                            // :emphasize-start:
                            ItemViewModel.create(
                                realm,
                                Item(ObjectId(), summary, currentUser!.id,
                                    priority: _priority));
                            // :emphasize-end:
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                ),
                // :remove-start:
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// :remove-end:
// ...closing brackets and parenthesis
// :snippet-end:
