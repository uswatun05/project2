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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.pink[200],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Keranjang Sampah 🗑️',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: deletedTodos.isEmpty
          ? Center(
              child: Text(
                'Keranjang sampah kosong',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            )
          : ListView.builder(
              itemCount: deletedTodos.length,
              itemBuilder: (context, index) {
                final todo = deletedTodos[index];
                return Card(
                  color: theme.cardColor,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      todo,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.restore),
                      color: textColor,
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
