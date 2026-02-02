import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../upload/domain/models/upload_state.dart';
import '../../../upload/presentation/controllers/upload_controller.dart';

class UploadingPostCard extends ConsumerWidget {
  final UploadState uploadState;

  const UploadingPostCard({
    super.key,
    required this.uploadState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cấu hình giao diện dựa trên Stage
    final config = _getStageConfig(uploadState.stage);

    // Format phần trăm: 45%
    final percentText = '${(uploadState.progress * 100).toInt()}%';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 1. Icon Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(config.icon, color: config.color, size: 28),
            ),
            const Gap(16),

            // 2. Nội dung Progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề trạng thái
                  Text(
                    config.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Gap(4),

                  // Thanh Progress hoặc Báo lỗi
                  if (uploadState.stage == UploadStage.failed)
                    Text(
                      uploadState.errorMessage ?? 'Lỗi không xác định',
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                      maxLines: 2,
                    )
                  else ...[
                    // Thanh Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: config.isIndeterminate
                            ? null
                            : uploadState.progress,
                        backgroundColor: Colors.grey.shade200,
                        color: config.color,
                        minHeight: 6,
                      ),
                    ),
                    const Gap(4),
                    // Text phụ: "45% • Đang tải lên server..."
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bọc Text description vào Expanded để nó tự co lại nếu dài quá
                        Expanded(
                          child: Text(
                            config.description,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                            maxLines: 1, // Giới hạn 1 dòng
                            overflow:
                                TextOverflow.ellipsis, // Hiện dấu ... nếu dài
                          ),
                        ),
                        const Gap(8),
                        if (!config.isIndeterminate)
                          Text(
                            percentText,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: config.color),
                          ),
                      ],
                    ),
                  ]
                ],
              ),
            ),

            // 3. Nút Cancel (Chỉ hiện khi chưa hoàn tất)
            if (uploadState.stage != UploadStage.completed &&
                uploadState.stage != UploadStage.failed)
              IconButton(
                onPressed: () {
                  ref.read(uploadControllerProvider.notifier).cancelUpload();
                },
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
              )
            else if (uploadState.stage == UploadStage.completed)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.check_circle, color: Colors.green),
              )
          ],
        ),
      ),
    );
  }

  // Hàm helper để lấy màu và text theo trạng thái
  _StageConfig _getStageConfig(UploadStage stage) {
    switch (stage) {
      case UploadStage.uploading:
        return _StageConfig(
          label: 'Đang tải file lên...',
          description: 'Đồng bộ dữ liệu lên đám mây',
          color: Colors.blue,
          icon: Icons.cloud_upload_outlined,
          isIndeterminate: false,
        );
      case UploadStage.confirming:
        return _StageConfig(
          label: 'Đang xác thực...',
          description: 'Vui lòng đợi trong giây lát',
          color: Colors.orange,
          icon: Icons.sync,
          isIndeterminate:
              true, // Chạy animation ko xác định vì chờ confirm API
        );
      case UploadStage.processing:
        return _StageConfig(
          label: 'AI đang xử lý...',
          description: 'Đang chuyển đổi giọng nói thành văn bản',
          color: Colors.purple, // Màu khác biệt cho giai đoạn xử lý
          icon: Icons.auto_awesome, // Icon AI
          isIndeterminate: false,
        );
      case UploadStage.completed:
        return _StageConfig(
          label: 'Hoàn tất!',
          description: 'Bài viết đã sẵn sàng',
          color: Colors.green,
          icon: Icons.check,
          isIndeterminate: false,
        );
      case UploadStage.failed:
        return _StageConfig(
          label: 'Tải lên thất bại',
          description: 'Vui lòng thử lại',
          color: Colors.red,
          icon: Icons.error_outline,
          isIndeterminate: false,
        );
      default:
        return _StageConfig(
          label: 'Đang chờ...',
          description: '...',
          color: Colors.grey,
          icon: Icons.hourglass_empty,
          isIndeterminate: true,
        );
    }
  }
}

class _StageConfig {
  final String label;
  final String description;
  final Color color;
  final IconData icon;
  final bool isIndeterminate;

  _StageConfig({
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
    required this.isIndeterminate,
  });
}
