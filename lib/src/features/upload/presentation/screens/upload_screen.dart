import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/upload_controller.dart';

class UploadScreen extends HookConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Biến để lưu file đã chọn (chưa upload)
    final selectedFile = useState<File?>(null);
    final fileName = useState<String>('');

    // Lắng nghe tiến độ từ Controller
    final uploadProgress = ref.watch(uploadControllerProvider);

    // Lắng nghe sự kiện (Thành công/Lỗi)
    ref.listen(uploadControllerProvider, (previous, next) {
      // 1. Chặn nhảy 2 lần nếu giá trị tiến độ không đổi
      if (previous?.value == next.value) return;

      if (next is AsyncError) {
        AppToast.showError(context, 'Upload thất bại: ${next.error}');
      } else if (next.value == 1.0) {
        // Nếu tiến độ là 1.0 (100%)
        AppToast.showSuccess(context, 'Upload hoàn tất! 🚀');

        // Reset file để upload cái khác
        selectedFile.value = null;
        fileName.value = '';

        // Redirect về trang chủ sau khi upload thành công
        context.go('/home');
      }
    });

    // Hàm chọn file
    Future<void> pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type:
            FileType.custom, // Dùng custom để mở Files app trên iOS ổn định hơn
        allowedExtensions: ['mp3', 'wav', 'm4a', 'flac', 'aac'],
      );

      if (result == null) {
        // User bấm Cancel không chọn file -> Dùng showInfo
        AppToast.showInfo(context, 'Bạn chưa chọn file nào');
        return;
      }

      if (result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileNameSelected = result.files.single.name;

        // Kiểm tra dung lượng (Ví dụ cảnh báo nếu file > 100MB)
        final fileSize = await file.length();
        final sizeInMb = fileSize / (1024 * 1024);

        if (sizeInMb > 100) {
          // Cảnh báo (Warning)
          AppToast.showWarning(context,
              'File lớn (${sizeInMb.toStringAsFixed(1)}MB), quá trình upload có thể lâu.');
        }

        selectedFile.value = file;
        fileName.value = fileNameSelected;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Upload MP3')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Khu vực hiển thị File
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
                        ? 'Chưa chọn file nào'
                        : fileName.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Gap(AppSizes.p24),

            // Thanh Loading
            if (uploadProgress.isLoading || uploadProgress.value != null) ...[
              LinearProgressIndicator(
                value: uploadProgress
                    .value, // Giá trị từ 0.0 -> 1.0 (null = indeterminate)
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const Gap(AppSizes.p8),
              if (uploadProgress.value != null)
                Text(
                  '${(uploadProgress.value! * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ] else ...[
              // Nút Chọn File (chỉ hiện khi không upload)
              if (selectedFile.value == null)
                PrimaryButton(
                  text: 'CHỌN FILE MP3',
                  onPressed: pickFile,
                )
              else
                // Nút Upload (chỉ hiện khi đã chọn file)
                PrimaryButton(
                  text: 'BẮT ĐẦU UPLOAD',
                  onPressed: () {
                    if (selectedFile.value != null) {
                      ref
                          .read(uploadControllerProvider.notifier)
                          .uploadFile(selectedFile.value!);
                    }
                  },
                ),

              // Nút chọn lại
              if (selectedFile.value != null)
                TextButton(
                  onPressed: pickFile,
                  child: const Text('Chọn file khác'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
