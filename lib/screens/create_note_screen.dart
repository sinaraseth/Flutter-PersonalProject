import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_taking_app/services/database_service.dart';

class CreateNoteScreen extends StatefulWidget {
  final Map<String, dynamic>? note;

  const CreateNoteScreen({super.key, this.note});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  bool _setDeadline = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _descriptionController.text = widget.note!['description'];
      _deadlineController.text = widget.note!['deadline'] ?? '';
      _setDeadline = widget.note!['deadline'] != null;
    }
  }

  Future<void> _selectDeadlineDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _deadlineController.text = DateFormat('dd/MM/yyyy HH:mm').format(finalDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff405D72),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
              ),
              cursorColor: Colors.grey,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffF7E7DC),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              const Text(
                'Deadline',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffF7E7DC),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: _setDeadline,
                  activeColor: const Color(0xFF758694),
                  activeTrackColor: Colors.lightGreenAccent,
                  inactiveThumbColor: const Color(0xFF758694),
                  inactiveTrackColor: const Color(0xffF7E7DC),
                  onChanged: (value) async {
                    setState(() => _setDeadline = value);
                    if (value) {
                      await _selectDeadlineDateTime(context);
                    } else {
                      setState(() => _deadlineController.clear());
                    }
                  },
                ),
              ),
              const Text(
                'Save',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffF7E7DC),
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                color: const Color(0xffF7E7DC),
                onPressed: _saveNote,
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_setDeadline && _deadlineController.text.isNotEmpty)
              Text(
                'Deadline: ${_deadlineController.text}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                  isDense: true,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() async {
    String title = _titleController.text.trim().isEmpty
        ? 'Untitled'
        : _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String deadline = _deadlineController.text.trim();

    if (description.isNotEmpty) {
      String date = DateTime.now().toIso8601String(); // Save the current date in ISO format
      try {
        if (widget.note == null) {
          // Create a new note
          await DatabaseService().addNote(
            title,
            description,
            date, // Save the current date when creating a new note
            deadline.isNotEmpty ? deadline : null, // Save the selected deadline
          );
        } else {
          // Update an existing note
          await DatabaseService().updateNote(
            widget.note!['id'],
            title,
            description,
            date, // Save the current date when updating the note
            deadline.isNotEmpty ? deadline : null, // Save the selected deadline
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving note: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty')),
      );
    }
  }
}