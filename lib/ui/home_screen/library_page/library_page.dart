import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/library_controller.dart';
import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/folder.dart';

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
                  controller.selectedFolder?.path ?? "",
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
                    leading: const Icon(Icons.folder_open),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentItem.name),
                        Text("${trackCount.toString()} Tracks"),
                      ],
                    ),
                    onTap: () => controller.selectFolder(currentItem),
                  );
                }
                if (currentItem is AudioFile) {
                  return ListTile(
                    leading: const Icon(Icons.audiotrack_outlined),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentItem.track.title),
                        Text(currentItem.track.artist ?? ""),
                      ],
                    ),
                    onTap: () => {},
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
