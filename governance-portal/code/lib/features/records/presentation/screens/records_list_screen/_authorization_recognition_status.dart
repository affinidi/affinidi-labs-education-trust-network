part of 'records_list_screen.dart';

class _AuthorizationRecognitionStatus extends StatelessWidget {
  final bool authorized;
  final bool recognized;

  const _AuthorizationRecognitionStatus({
    required this.authorized,
    required this.recognized,
  });

  @override
  Widget build(BuildContext context) {
    final activeTags = <Widget>[];

    if (authorized) {
      activeTags.add(
        _StatusTag(
          label: 'Authorized',
          isPositive: true,
        ),
      );
    }

    if (recognized) {
      if (activeTags.isNotEmpty) {
        activeTags.add(const SizedBox(width: 8));
      }
      activeTags.add(
        _StatusTag(
          label: 'Recognized',
          isPositive: true,
        ),
      );
    }

    // If no active status, show a dash or empty state
    if (activeTags.isEmpty) {
      return const Text('—');
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: activeTags,
    );
  }
}
