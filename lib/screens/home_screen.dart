import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note_card.dart';
import 'package:note_taking_app/screens/create_note_screen.dart';
import 'package:note_taking_app/screens/view_note_screen.dart';
import 'package:note_taking_app/services/database_service.dart';

class AllNoteScreen extends StatefulWidget {
  const AllNoteScreen({super.key});

  @override
  State<AllNoteScreen> createState() => _AllNoteScreenState();
}

class _AllNoteScreenState extends State<AllNoteScreen> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await DatabaseService().getNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading notes: $e')),
      );
    }
  }

  Future<void> _deleteNoteById(int id) async {
    try {
      await DatabaseService().deleteNoteById(id);
      await _loadNotes(); // Refresh notes after deletion
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  void _navigateToCreateNote({Map<String, dynamic>? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNoteScreen(note: note),
      ),
    );
    if (result == true) {
      _loadNotes(); // Reload notes after editing
    }
  }

  // Navigate to ViewNoteScreen
  void _navigateToViewNoteScreen(
      String title, String description, String date, String? deadline) {
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
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateNote(),
        tooltip: 'Add a Note',
        backgroundColor: const Color(0xFF758694),
        child: const Image(
            image: AssetImage('assets/noteAdd.png'), 
            width: 40, 
            height: 40,
            color: Colors.white
          ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xff405D72),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'All Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notes.isEmpty
                      ? const Center(
                          child: Text(
                            'No notes available. Add a new one!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: _notes.length,
                            itemBuilder: (context, index) {
                              final note = _notes[index];
                              return NoteCard(
                                key: Key(note['id'].toString()), // Use note ID as the key
                                title: note['title'],
                                description: note['description'],
                                date: _formatDate(note['date']),
                                deadline: note['deadline'],
                                onDelete: () => _deleteNoteById(note['id']),
                                onEdit: () => _navigateToCreateNote(note: note),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}