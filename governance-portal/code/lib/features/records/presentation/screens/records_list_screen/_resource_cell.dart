part of 'records_list_screen.dart';

class _ResourceCell extends StatelessWidget {
  final String text;

  const _ResourceCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      child: Text(
        text,
        softWrap: false,
      ),
    );
  }
}
