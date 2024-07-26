import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/providers.dart';

class PlayPauseButton extends ConsumerWidget {
  const PlayPauseButton({
    super.key,
    required this.callback,
    required this.iconData,
    required this.buttonSize,
    this.color = Colors.indigo,
  });

  final VoidCallback callback;
  final IconData iconData;
  final double buttonSize;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ref.watch(queueProvider).trackColor ?? color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(360),
          splashColor: Colors.grey,
          onTap: callback,
          child: Center(
            child: FaIcon(
              iconData,
              color: Theme.of(context).colorScheme.inverseSurface,
              size: buttonSize / 2,
            ),
          ),
        ),
      ),
    );
  }
}
