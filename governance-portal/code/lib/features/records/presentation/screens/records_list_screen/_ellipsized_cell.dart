part of 'records_list_screen.dart';

class _EllipsizedCell extends StatelessWidget {
  final String text;
  final double maxWidth;

  const _EllipsizedCell({
    required this.text,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
