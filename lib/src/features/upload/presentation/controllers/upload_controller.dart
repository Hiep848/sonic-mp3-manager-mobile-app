import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/upload_remote_datasource.dart';
import '../../data/repositories/upload_repository_impl.dart';
import '../../domain/models/upload_state.dart';

part 'upload_controller.g.dart';

@Riverpod(keepAlive: true)
class UploadController extends _$UploadController {
  CancelToken? _cancelToken;

  @override
  UploadState build() {
    return const UploadState(stage: UploadStage.idle);
  }

  Future<void> uploadFile(File file) async {
    state = const UploadState(stage: UploadStage.uploading, progress: 0.0);
    _cancelToken = CancelToken();

    final dataSource = ref.read(uploadRemoteDataSourceProvider);
    String? currentJobId;

    try {
      final fileName = file.path.split('/').last;
      final initData = await dataSource.initUpload(fileName, 'audio/mpeg');
      currentJobId = initData.jobId;
      state = state.copyWith(jobId: currentJobId);
      if (_cancelToken!.isCancelled) throw _cancelToken!.cancelError!;
      await dataSource.uploadFileToS3(
          url: initData.uploadUrl,
          file: file,
          contentType: 'audio/mpeg',
          cancelToken: _cancelToken,
          onSendProgress: (sent, total) {
            if (!_cancelToken!.isCancelled) {
              state = state.copyWith(progress: sent / total);
            }
          });

      state = state.copyWith(stage: UploadStage.confirming, progress: 1.0);
      final fileSize = await file.length();

      final player = AudioPlayer();
      final duration = await player.setFilePath(file.path);
      final durationInSeconds = duration?.inSeconds.toDouble() ?? 0.0;
      await player.dispose();
      await dataSource.confirmUpload(
        currentJobId,
        fileName,
        durationInSeconds,
        fileSize,
      );
      state = state.copyWith(stage: UploadStage.processing, progress: 0.0);
      final sseStream = dataSource.listenToProcessingProgress(currentJobId);
      await for (final event in sseStream) {
        if (_cancelToken?.isCancelled ?? false) break;

        final status = event['status'];
        dynamic progressRaw = event['progress'];
        double progressVal = 0.0;
        if (progressRaw is num) {
          progressVal = progressRaw.toDouble();
        } else if (progressRaw is String) {
          progressVal = double.tryParse(progressRaw) ?? 0.0;
        }
        final progress = progressVal > 1 ? progressVal / 100.0 : progressVal;
        if (status == 'COMPLETED') {
          state = state.copyWith(stage: UploadStage.completed, progress: 1.0);
          break;
        } else if (status == 'FAILED' || status == 'CANCELLED') {
          throw Exception(event['message'] ?? 'Xử lý thất bại');
        } else {
          // Only update progress if not cancelled
          if (!(_cancelToken?.isCancelled ?? false)) {
            state = state.copyWith(
                stage: UploadStage.processing, progress: progress);
          }
        }
      }

      await Future.delayed(const Duration(seconds: 3));
      // Only set to idle if not cancelled (if cancelled, it's already idle or handled)
      if (!(_cancelToken?.isCancelled ?? false)) {
        state = const UploadState(stage: UploadStage.idle);
      }
    } catch (e, st) {
      print("Upload failed: $e\n$st");
      // Check if cancelled
      if ((_cancelToken != null && _cancelToken!.isCancelled) ||
          (e is DioException && e.type == DioExceptionType.cancel)) {
        state = const UploadState(stage: UploadStage.idle);
      } else {
        state = state.copyWith(
            stage: UploadStage.failed, errorMessage: e.toString());
        Future.delayed(const Duration(seconds: 5), () {
          // Only reset if still failed (user didn't start new upload)
          if (state.stage == UploadStage.failed) {
            state = const UploadState(stage: UploadStage.idle);
          }
        });
      }
    } finally {
      _cancelToken = null;
    }
  }

  Future<void> cancelUpload() async {
    final currentStage = state.stage;
    final currentJobId = state.jobId;
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("User cancelled");
    }
    if (currentJobId != null &&
        (currentStage == UploadStage.confirming ||
            currentStage == UploadStage.processing)) {
      try {
        final repo = ref.read(uploadRepositoryProvider);
        await repo.cancelJob(currentJobId);
      } catch (e) {
        print("Backend cancel failed: $e");
      }
    }
    state = const UploadState(stage: UploadStage.idle);
  }
}
