import 'package:flutter/material.dart';
import 'package:note_taking_app/screens/view_note_screen.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String? deadline;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const NoteCard({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    this.deadline,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String truncatedDescription = description.length > 50
        ? description.substring(0, 50) + '...'
        : description;

    return Dismissible(
      key: key!,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.blue),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onEdit();
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                truncatedDescription,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewNoteScreen(
                  title: title,
                  description: description,
                  date: date,
                  deadline: deadline,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}