import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../l10n/app_localizations.dart';
import '../controllers/album_actions_controller.dart';

class CreateAlbumDialog extends ConsumerStatefulWidget {
  const CreateAlbumDialog({super.key});

  @override
  ConsumerState<CreateAlbumDialog> createState() => _CreateAlbumDialogState();
}

class _CreateAlbumDialogState extends ConsumerState<CreateAlbumDialog> {
  final _titleController = TextEditingController();

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final controller = ref.read(albumActionsControllerProvider.notifier);
    await controller.createAlbum(title);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We can also listen to state to show loading/error
    final state = ref.watch(albumActionsControllerProvider);
    final l10n = AppLocalizations.of(
        context)!; // Assuming localized strings exist or fallback

    // Fallback strings if L10n not ready for new keys
    // We should ideally add to arb file, but for now hardcode/use basic or assume keys
    // Let's assume keys: albumCreateTitle, albumInputName, cancel, create

    return AlertDialog(
      title: Text(l10n.albumCreateNew), // TODO: use l10n
      content: TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: l10n.albumNameHint,
        ),
        autofocus: true,
      ),
      actions: [
        ElevatedButton(
          onPressed: state.isLoading ? null : _submit,
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.albumCreateButton),
        ),
      ],
    );
  }
}
