import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/models/upload_state.dart'; // Import State mới
import '../controllers/upload_controller.dart';

class UploadScreen extends HookConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFile = useState<File?>(null);
    final fileName = useState<String>('');

    // [FIX] Lắng nghe trực tiếp UploadState (không còn là AsyncValue)
    final uploadState = ref.watch(uploadControllerProvider);

    // [FIX] Cập nhật logic listen
    ref.listen(uploadControllerProvider, (previous, next) {
      // 1. Xử lý lỗi
      if (next.stage == UploadStage.failed) {
        AppToast.showError(context, 'Lỗi: ${next.errorMessage}');
      }
      // 2. Nếu bắt đầu upload -> Đóng màn hình ngay (để hiện progress ở Feed)
      else if (next.stage == UploadStage.uploading &&
          previous?.stage == UploadStage.idle) {
        AppToast.showInfo(
            context, AppLocalizations.of(context)!.uploadInBackground);
        context.pop(); // Quay về Feed
      }
    });

    Future<void> pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'flac', 'aac'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        fileName.value = result.files.single.name;
      }
    }

    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.uploadScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.audio_file, size: 48, color: Colors.blue),
                  const Gap(AppSizes.p8),
                  Text(
                    selectedFile.value == null
                        ? AppLocalizations.of(context)!.uploadNoFileSelected
                        : fileName.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Gap(AppSizes.p24),
            if (selectedFile.value == null)
              PrimaryButton(
                text: AppLocalizations.of(context)!.uploadButtonPick,
                onPressed: pickFile,
              )
            else
              PrimaryButton(
                text: AppLocalizations.of(context)!.uploadButtonStart,
                isLoading: uploadState.stage != UploadStage.idle &&
                    uploadState.stage != UploadStage.failed,
                onPressed: () {
                  if (selectedFile.value != null) {
                    ref
                        .read(uploadControllerProvider.notifier)
                        .uploadFile(selectedFile.value!);
                  }
                },
              ),
            if (selectedFile.value != null)
              TextButton(
                onPressed: pickFile,
                child: Text(AppLocalizations.of(context)!.uploadButtonChange),
              ),
          ],
        ),
      ),
    );
  }
}
