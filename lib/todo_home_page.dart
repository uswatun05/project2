import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'trash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<String> _deletedTodos = [];
  final List<String> _todos = [];
  final List<String> _filteredTodos = [];
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      setState(() {
        _todos.addAll(List<String>.from(jsonDecode(todosString)));
        _filteredTodos.addAll(_todos);
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', jsonEncode(_todos));
  }

  void _restoreTodoFromTrash(String todo) {
    setState(() {
      _deletedTodos.remove(todo);
      _todos.add(todo);
      _onSearchChanged(_searchQuery);
    });
    _saveTodos();
  }

  void _addTodo() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _todos.add(text);
        _controller.clear();
        _onSearchChanged(_searchQuery);
      });
      _saveTodos();
    }
  }

  void _removeTodo(int index) {
    final removedText = _filteredTodos[index];
    setState(() {
      _deletedTodos.add(removedText);
      _todos.remove(removedText);
      _onSearchChanged(_searchQuery);
    });
    _saveTodos();
  }

  void _confirmRemove(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: const Text('Hapus Tugas'),
        content: const Text('Yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _removeTodo(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _editTodoDialog(int index) {
    final TextEditingController editController =
        TextEditingController(text: _filteredTodos[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: const Text('Edit Tugas'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            labelText: 'Ubah tugas',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final newText = editController.text;
              if (newText.isNotEmpty) {
                final oldText = _filteredTodos[index];
                final realIndex = _todos.indexOf(oldText);
                setState(() {
                  _todos[realIndex] = newText;
                  _onSearchChanged(_searchQuery);
                });
                _saveTodos();
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTodos.clear();
      if (_searchQuery.isEmpty) {
        _filteredTodos.addAll(_todos);
      } else {
        _filteredTodos.addAll(
          _todos.where((todo) =>
              todo.toLowerCase().contains(_searchQuery.toLowerCase())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[900]
      : Colors.pink[200],

        centerTitle: true,
        title: Text(
          'Catatan Harian📚',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      
        actions: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) => IconButton(
                icon: Icon(
                  mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  themeNotifier.value =
                      mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                },
              ),
            ),
          ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _onSearchChanged,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Cari Tugas',
                labelStyle: GoogleFonts.poppins(color: textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Tambahkan Tugas',
                      labelStyle: GoogleFonts.poppins(color: textColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Tambah',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredTodos.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada tugas',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTodos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: theme.cardColor,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              _filteredTodos[index],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: textColor,
                                  onPressed: () => _confirmRemove(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: textColor,
                                  onPressed: () => _editTodoDialog(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrashPage(
                      deletedTodos: _deletedTodos,
                      restoreTodo: _restoreTodoFromTrash,
                    ),
                  ),
                );
              },
              child: Text(
                'Lihat Keranjang Sampah',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.pink
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
