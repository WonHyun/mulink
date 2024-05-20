import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/folder.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/home_screen/library_page/media_list_item.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryProvider);
    final libraryController = ref.watch(libraryProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: libraryController.moveToParent,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            IconButton(
              onPressed: libraryController.setRootPath,
              icon: const Icon(Icons.folder_open),
            ),
            Expanded(
              child: Text(
                libraryState.selectedFolder?.path.split("/").last ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: libraryState.selectedFolder?.children.length ?? 0,
            itemBuilder: (context, index) {
              final currentItem = libraryState.selectedFolder?.children[index];
              if (currentItem is Folder) {
                final trackCount =
                    currentItem.children.whereType<AudioFile>().length;
                return ListTile(
                  leading: const Icon(
                    Icons.folder_open,
                    size: 50,
                  ),
                  title: Text(
                    currentItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text("${trackCount.toString()} Tracks"),
                  trailing: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.more_vert),
                  ),
                  onTap: () => libraryController.selectFolder(currentItem),
                );
              }
              if (currentItem is AudioFile) {
                return MediaListItem(
                  track: currentItem.track,
                  callback: () =>
                      libraryController.selectAudioFile(currentItem),
                  isSelected: libraryState.selectedAudio == currentItem,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
