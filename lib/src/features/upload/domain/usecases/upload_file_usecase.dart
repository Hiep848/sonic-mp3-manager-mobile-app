import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/upload_repository_impl.dart';
import '../repositories/upload_repository.dart';

part 'upload_file_usecase.g.dart';

@riverpod
UploadFileUseCase uploadFileUseCase(UploadFileUseCaseRef ref) {
  final repository = ref.watch(uploadRepositoryProvider);
  return UploadFileUseCase(repository);
}

class UploadFileUseCase {
  final UploadRepository _repository;

  UploadFileUseCase(this._repository);

  Stream<double> call(File file, CancelToken cancelToken) async* {
    // 0. Start
    yield 0.0;
    
    // 1. Init Upload
    final fileName = file.path.split('/').last;
    final initResponse = await _repository.initUpload(fileName);
    
    if (cancelToken.isCancelled) throw cancelToken.cancelError!;

    // 2. Upload to S3 (Direct Put)
    final uploadController = StreamController<double>();
    
    // Listen to progress from repo and add to stream
    // We use a separate stream controller or just yield inside loop if we could await?
    // Actually generator functions (async*) can't easily wait for callback.
    // So we'll use a local variable state or callback bridging.
    // Simpler: Just rely on Future, but for progress we need the callback.
    // Let's use a Completer to simple bridging.
    
    double currentProgress = 0.0;
    
    // We can't yield from a callback.
    // So we will just pass a callback that updates a variable, and maybe we don't yield fine-grained progress here?
    // No, UI needs progress.
    // Solution: The repository `uploadFile` method is a Future.
    // But we need to yield stream events. 
    // Let's change this UseCase to return a Stream that emits progress.
    
    // Actually, simple bridging:
    // Create a StreamController, pipe events to it, return its stream.
    // But `async*` is already a stream.
    // We can just yield updates between steps.
    // For the S3 upload step (which takes time), we need to bridge the callback to yield.
    // THIS IS HARD with `async*`.
    // Easier pattern: Use a simpler approach where we yield major steps or just blocking wait.
    
    // PROPER WAY: Use `await for` with a Stream created from the callback?
    // Let's try attempting upload and yielding progress by converting callback to Stream.
    
    // Actually, let's keep it simple for now and rely on Repository being awaited.
    // But to get progress, we must change strategy.
    
    // Let's create a StreamController to act as the bridge.
    final controller = StreamController<double>();
    
    // We will perform the work in the background and pipe to controller.
    Future<void> run() async {
      try {
        // Step 1: Init
        controller.add(0.01); // Started
        final response = await _repository.initUpload(fileName);
        
        if (cancelToken.isCancelled) throw cancelToken.cancelError!;

        // Step 2: Upload
        await _repository.uploadFile(
          response.presignedUrl, 
          file, 
          cancelToken, 
          (progress) {
             controller.add(progress * 0.95); // Scale progress to 95%
          }
        );
        
        if (cancelToken.isCancelled) throw cancelToken.cancelError!;
        
        // Step 3: Confirm
        await _repository.confirmUpload(response.jobId);
        
        controller.add(1.0); // Done
        controller.close();
      } catch (e) {
        controller.addError(e);
        controller.close();
      }
    }
    
    run();
    
    yield* controller.stream;
  }
}
