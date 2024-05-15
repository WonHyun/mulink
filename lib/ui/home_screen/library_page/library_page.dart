import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/file_explorer_controller.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FileExplorerController controller = Get.find();
    return GetBuilder<FileExplorerController>(builder: (_) {
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: controller.moveToParentDirectory,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: controller.setRootPath,
                icon: const Icon(Icons.folder_open),
              ),
              Expanded(
                child: Text(
                  controller.currentDirectory?.path ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          controller.currentDirectory == null
              ? const SizedBox.shrink()
              : Expanded(
                  child: ListView(
                    children: controller.currentDirectory!.listSync().map(
                      (item) {
                        return ListTile(
                          title: Text(item.path.split('/').last),
                          onTap: () {
                            if (FileSystemEntity.isDirectorySync(item.path)) {
                              controller
                                  .setCurrentDirectory(Directory(item.path));
                            } else {}
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
        ],
      );
    });
  }
}
