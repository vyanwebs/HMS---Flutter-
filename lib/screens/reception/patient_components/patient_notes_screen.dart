import 'package:flutter/material.dart';
import 'package:hms/models/ipd_patient_model.dart';

class PatientNotesScreen extends StatefulWidget {
  final IPDPatient patient;

  const PatientNotesScreen({super.key, required this.patient});

  @override
  State<PatientNotesScreen> createState() => _PatientNotesScreenState();
}

class _PatientNotesScreenState extends State<PatientNotesScreen> {
  final List<PatientNote> _notes = [];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSampleNotes();
  }

  void _loadSampleNotes() {
    _notes.addAll([
      PatientNote(
        content:
            'Patient complained of headache. Administered paracetamol 500mg.',
        author: 'Nurse Sarah',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'Medical',
      ),
      PatientNote(
        content: 'Blood pressure: 120/80 mmHg. Temperature: 98.6°F',
        author: 'Dr. Sharma',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: 'Vitals',
      ),
      PatientNote(
        content: 'Patient resting comfortably. No complaints.',
        author: 'Nurse John',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: 'General',
      ),
    ]);
  }

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _notes.insert(
          0,
          PatientNote(
            content: _noteController.text,
            author: 'Reception',
            timestamp: DateTime.now(),
            type: 'General',
          ),
        );
        _noteController.clear();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Notes - ${widget.patient.name}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4299E1)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Add Note Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4299E1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          // Notes List
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notes_outlined,
                          size: 60,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No notes yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return _buildNoteCard(_notes[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(PatientNote note, int index) {
    Color typeColor;
    IconData typeIcon;
    switch (note.type) {
      case 'Medical':
        typeColor = const Color(0xFFF56565);
        typeIcon = Icons.medical_services_outlined;
        break;
      case 'Vitals':
        typeColor = const Color(0xFFED8936);
        typeIcon = Icons.monitor_heart_outlined;
        break;
      default:
        typeColor = const Color(0xFF4299E1);
        typeIcon = Icons.notes_outlined;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        typeIcon,
                        size: 16,
                        color: typeColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      note.type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: typeColor,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF718096)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Color(0xFF4299E1)),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete,
                              size: 18, color: Color(0xFFF56565)),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                      onTap: () => _deleteNote(index),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              note.content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4299E1).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xFF4299E1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      note.author,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatTimeAgo(note.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class PatientNote {
  final String content;
  final String author;
  final DateTime timestamp;
  final String type;

  PatientNote({
    required this.content,
    required this.author,
    required this.timestamp,
    required this.type,
  });
}
