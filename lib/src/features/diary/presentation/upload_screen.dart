import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mp3_management/src/features/diary/domain/models/mood.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/image_picker_grid.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/mood_chip.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/upload_progress_widget.dart';

import '../../../../l10n/app_localizations.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _hashtagController = TextEditingController();

  Mood _selectedMood = Mood.neutral;
  DateTime _recordDate = DateTime.now();
  String? _selectedAlbum;
  final List<String> _hashtags = [];
  final List<String> _attachedImages = [];
  String? _pickedMp3Name;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: UploadProgressWidget(progress: _uploadProgress),
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.uploadTitle),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(l10n.uploadSave),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.uploadInputTitle,
                hintText: l10n.uploadInputTitleHint,
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Date Picker (Mock)
            GestureDetector(
              onTap: _pickDate,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.uploadDateLabel} ${_recordDate.day}/${_recordDate.month}/${_recordDate.year}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mood
            Text(l10n.uploadMoodLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Mood.values.map((mood) {
                return MoodChip(
                  mood: mood,
                  isSelected: _selectedMood == mood,
                  onTap: () {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Album Dropdown
            DropdownButtonFormField<String>(
              value: _selectedAlbum,
              decoration: InputDecoration(labelText: l10n.uploadAlbumLabel),
              items: [
                const DropdownMenuItem(
                    value: 'album_1', child: Text('Travel 2024')),
                const DropdownMenuItem(
                    value: 'album_2', child: Text('Daily Thoughts')),
                DropdownMenuItem(
                    value: 'new', child: Text(l10n.uploadAlbumNew)),
              ],
              onChanged: (val) {
                setState(() => _selectedAlbum = val);
              },
            ),
            const SizedBox(height: 24),

            // Mock MP3 Picker
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.audio_file, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _pickedMp3Name ?? l10n.uploadAudioNoFile,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pickedMp3Name = 'recording_2026_01_30.mp3';
                      });
                    },
                    child: Text(l10n.uploadAudioPick),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Text Content
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: l10n.uploadContentLabel,
                alignLabelWithHint: true,
                hintText: l10n.uploadContentHint,
              ),
            ),
            const SizedBox(height: 24),

            // Hashtags
            TextField(
              controller: _hashtagController,
              decoration: InputDecoration(
                labelText: l10n.uploadHashtagLabel,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addHashtag,
                ),
              ),
              onSubmitted: (_) => _addHashtag(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _hashtags
                  .map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() {
                            _hashtags.remove(tag);
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // Images
            Text(l10n.uploadAttachments,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ImagePickerGrid(
              images: _attachedImages,
              onAdd: () {
                if (_attachedImages.length < 3) {
                  setState(() {
                    _attachedImages.add(
                        'https://picsum.photos/seed/${DateTime.now().millisecond}/300/300');
                  });
                }
              },
              onRemove: (index) {
                setState(() {
                  _attachedImages.removeAt(index);
                });
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _recordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _recordDate = picked);
    }
  }

  void _addHashtag() {
    final text = _hashtagController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _hashtags.add(text.startsWith('#') ? text : '#$text');
        _hashtagController.clear();
      });
    }
  }

  void _submit() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.uploadErrorTitle)),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulate upload
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _uploadProgress = i / 10.0;
      });
    }

    if (mounted) {
      context.pop(); // Return to Home
    }
  }
}
