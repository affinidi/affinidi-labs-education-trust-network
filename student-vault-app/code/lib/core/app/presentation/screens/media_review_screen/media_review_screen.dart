import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../infrastructure/configuration/environment.dart';
import '../../../../infrastructure/extensions/build_context_extensions.dart';
import '../../../../navigation/navigator.dart';
import '../../widgets/bottom_media_bar.dart';
import '../../widgets/image_preview.dart';
import '../media_screen/media_screen.dart';
import 'media_review_controller.dart';

class MediaReviewScreen extends HookConsumerWidget {
  const MediaReviewScreen({
    super.key,
    this.useChatSemantics = false,
    required this.imageBytes,
    this.messageText,
  });

  final bool useChatSemantics;
  final Uint8List? imageBytes;
  final String? messageText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = useTextEditingController(text: messageText);
    final isSending = useState(false);
    final controller = ref.read(mediaReviewControllerProvider.notifier);

    Future<void> submitResult({required bool success}) async {
      final navigator = ref.read(navigatorProvider);
      if (imageBytes == null) {
        navigator.pop(MediaReviewResult.empty());
        return;
      }

      isSending.value = true;

      final environment = ref.read(environmentProvider);
      final reviewResult = await controller.submitResult(
        bytes: imageBytes!,
        success: success,
        message: messageController.text,
        imageConfig: useChatSemantics
            ? environment.chatImageConfig
            : environment.profileImageConfig,
      );

      if (context.mounted) navigator.pop(reviewResult);

      isSending.value = false;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: ImagePreview(imageBytes: imageBytes)),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomMediaBar(
              children: [
                if (useChatSemantics)
                  Expanded(
                    child: _MessageInput(
                      controller: messageController,
                      isSending: isSending.value,
                      onSend: () => submitResult(success: true),
                    ),
                  )
                else
                  const Spacer(),
                if (useChatSemantics) const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 2,
                  backgroundColor: Colors.red,
                  onPressed: () => submitResult(success: false),
                  child: const Icon(
                    Icons.cancel_sharp,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                if (imageBytes != null)
                  FloatingActionButton(
                    heroTag: 1,
                    backgroundColor: Colors.green,
                    onPressed: isSending.value
                        ? null
                        : () => submitResult(success: true),
                    child: Icon(
                      useChatSemantics ? Icons.send : Icons.done,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 49, 49, 51),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        minLines: 1,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.send,
        onSubmitted: isSending ? null : (_) => onSend(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          hintMaxLines: 1,
          hintText: context.l10n.chatAddMessageToMediaPrompt,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
