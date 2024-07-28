import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/component/play_state_button.dart';

class MediaControlPanel extends ConsumerWidget {
  const MediaControlPanel({
    super.key,
    required this.iconSize,
    this.horizontalPadding = 20,
  });

  final double iconSize;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: playerNotifier.previous,
          icon: Icon(
            FontAwesomeIcons.backwardStep,
            size: iconSize * 0.7,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SizedBox(
            width: iconSize * 1.5,
            height: iconSize * 1.5,
            child: PlayStateButton(
              playButtonState: playerState.playButtonState,
              onPlay: playerNotifier.play,
              onPause: playerNotifier.pause,
              buttonSize: iconSize,
            ),
          ),
        ),
        IconButton(
          onPressed: playerNotifier.next,
          icon: Icon(
            FontAwesomeIcons.forwardStep,
            size: iconSize * 0.7,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      ],
    );
  }
}
