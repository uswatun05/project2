import 'package:flutter/material.dart';

class TrashPage extends StatelessWidget {
  final List<String> deletedTodos;
    final Function(String) restoreTodo;

  const TrashPage({
    Key? key, 
    required this.deletedTodos,
    required this.restoreTodo,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Keranjang Sampah'),
      ),
      body: deletedTodos.isEmpty
          ? const Center(child: Text('Keranjang sampah kosong'))
          : ListView.builder(
              itemCount: deletedTodos.length,
              itemBuilder: (context, index) {
                final todo = deletedTodos[index];
                return Card(
                color: Colors.lightBlue[50],
                  child: ListTile(
                    title: Text(deletedTodos[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.restore),
                      onPressed: () {
                        // Mengembalikan tugas ke daftar tugas utama
                        restoreTodo(todo);
                        Navigator.pop(context); // Kembali ke halaman utama
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}