import 'package:flutter/material.dart';

class ViewNoteScreen extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String? deadline;

  const ViewNoteScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff405D72),
        title: const Text('View Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (deadline != null && deadline!.isNotEmpty)
                Text(
                  'Deadline: $deadline',
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}