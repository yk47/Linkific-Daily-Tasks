import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF235789),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class TodoItem {
  TodoItem({required this.id, required this.title, this.completed = false});

  final int id;
  String title;
  bool completed;
}

class _TodoHomePageState extends State<TodoHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final List<TodoItem> _todos = <TodoItem>[];

  int _nextId = 1;
  String _searchQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<TodoItem> get _filteredTodos {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return List.unmodifiable(_todos);
    }

    return _todos
        .where((todo) => todo.title.toLowerCase().contains(query))
        .toList(growable: false);
  }

  void _addTodo() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final title = _controller.text.trim();
    setState(() {
      _todos.insert(0, TodoItem(id: _nextId++, title: title));
    });

    _controller.clear();
    _focusNode.requestFocus();
  }

  void _toggleTodo(TodoItem todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _removeTodo(TodoItem todo) {
    setState(() {
      _todos.removeWhere((item) => item.id == todo.id);
    });
  }

  Future<void> _editTodo(TodoItem todo) async {
    final editController = TextEditingController(text: todo.title);
    final formKey = GlobalKey<FormState>();

    final updatedTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit task'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: editController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Task title'),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(editController.text.trim());
                }
              },
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'Enter a task title';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(editController.text.trim());
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedTitle == null || updatedTitle == todo.title) {
      return;
    }

    setState(() {
      todo.title = updatedTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleTodos = _filteredTodos;
    final completedCount = _todos.where((todo) => todo.completed).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List'), centerTitle: false),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FB), Color(0xFFE5F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeaderCard(
                totalCount: _todos.length,
                completedCount: completedCount,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          key: const Key('todoInput'),
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Add a task',
                            hintText: 'Read state docs',
                            prefixIcon: Icon(Icons.task_alt),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _addTodo(),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) {
                              return 'Enter a task title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          key: const Key('addTodoButton'),
                          onPressed: _addTodo,
                          icon: const Icon(Icons.add),
                          label: const Text('Add task'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('searchField'),
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search tasks',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (visibleTodos.isEmpty)
                _EmptyState(
                  hasFilter: _searchQuery.trim().isNotEmpty,
                  onClearFilter: _searchQuery.trim().isEmpty
                      ? null
                      : () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                )
              else
                ...visibleTodos.map(
                  (todo) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: ValueKey(todo.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _removeTodo(todo),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      child: Card(
                        elevation: 0,
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (_) => _toggleTodo(todo),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: todo.completed
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            todo.completed ? 'Completed' : 'Active',
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                tooltip: 'Edit task',
                                onPressed: () => _editTodo(todo),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                tooltip: 'Delete task',
                                onPressed: () => _removeTodo(todo),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          onTap: () => _toggleTodo(todo),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.totalCount, required this.completedCount});

  final int totalCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stateful Todo Board',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Use setState to add, edit, complete, and remove tasks.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatChip(label: 'Total', value: totalCount.toString()),
                _StatChip(label: 'Done', value: completedCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilter, this.onClearFilter});

  final bool hasFilter;
  final VoidCallback? onClearFilter;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              hasFilter ? Icons.search_off : Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              hasFilter ? 'No tasks match your search' : 'No tasks yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              hasFilter
                  ? 'Clear the search or add a task to get started.'
                  : 'Add your first task to see local state in action.',
              textAlign: TextAlign.center,
            ),
            if (onClearFilter != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onClearFilter,
                child: const Text('Clear search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
