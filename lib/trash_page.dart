import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
        centerTitle: true,
        title: Text(
          'Keranjang Sampah 🗑️',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: deletedTodos.isEmpty
          ? Center(
              child: Text(
                'Keranjang sampah kosong',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            )
          : ListView.builder(
              itemCount: deletedTodos.length,
              itemBuilder: (context, index) {
                final todo = deletedTodos[index];
                return Card(
                  color: isDark ? Colors.grey[800] : Colors.grey[50],
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      todo,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.restore), 
                      color: isDark ? Colors.white: Colors.black,
                      onPressed: () {
                        restoreTodo(todo);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
