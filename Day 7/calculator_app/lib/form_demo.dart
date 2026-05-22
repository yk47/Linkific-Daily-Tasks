import 'package:flutter/material.dart';

class FormDemoPage extends StatefulWidget {
  const FormDemoPage({super.key});

  @override
  State<FormDemoPage> createState() => _FormDemoPageState();
}

class _FormDemoPageState extends State<FormDemoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _valueCtrl = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _valueFocus = FocusNode();

  final List<Map<String, String>> _items = [];
  String _filter = '';
  int? _editingIndex;

  List<Map<String, String>> get _visibleItems {
    if (_filter.isEmpty) return _items;
    return _items
        .where((i) => i['name']!.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final value = _valueCtrl.text.trim();
    setState(() {
      if (_editingIndex != null) {
        _items[_editingIndex!] = {'name': name, 'value': value};
        _editingIndex = null;
      } else {
        _items.add({'name': name, 'value': value});
      }
      _nameCtrl.clear();
      _valueCtrl.clear();
      _nameFocus.requestFocus();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  void _edit(int index) {
    setState(() {
      _editingIndex = index;
      _nameCtrl.text = _items[index]['name']!;
      _valueCtrl.text = _items[index]['value']!;
      _nameFocus.requestFocus();
    });
  }

  void _remove(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _nameFocus.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
                  onFieldSubmitted: (_) => _valueFocus.requestFocus(),
                ),
                TextFormField(
                  controller: _valueCtrl,
                  focusNode: _valueFocus,
                  decoration: const InputDecoration(labelText: 'Value'),
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a value' : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(_editingIndex == null ? 'Add' : 'Update'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _editingIndex = null;
                          _nameCtrl.clear();
                          _valueCtrl.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Filter list',
            ),
            onChanged: (s) => setState(() => _filter = s),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _visibleItems.isEmpty
                ? const Center(child: Text('No items'))
                : ListView.builder(
                    itemCount: _visibleItems.length,
                    itemBuilder: (context, idx) {
                      final actualIndex = _items.indexOf(_visibleItems[idx]);
                      final item = _visibleItems[idx];
                      return ListTile(
                        title: Text(item['name']!),
                        subtitle: Text(item['value']!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _edit(actualIndex),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _remove(actualIndex),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
