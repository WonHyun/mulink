import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/library_controller.dart';
import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/folder.dart';
import 'package:mulink/ui/home_screen/library_page/media_list_item.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LibraryController controller = Get.find();
    return GetBuilder<LibraryController>(builder: (_) {
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: controller.moveToParent,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: controller.setRootPath,
                icon: const Icon(Icons.folder_open),
              ),
              Expanded(
                child: Text(
                  controller.selectedFolder?.path.split("/").last ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: controller.selectedFolder?.children.length ?? 0,
              itemBuilder: (context, index) {
                final currentItem = controller.selectedFolder?.children[index];
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
                    onTap: () => controller.selectFolder(currentItem),
                  );
                }
                if (currentItem is AudioFile) {
                  return MediaListItem(
                    track: currentItem.track,
                    callback: () => controller.selectAudioFile(currentItem),
                    isSelected: controller.selectedAudio == currentItem,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      );
    });
  }
}
