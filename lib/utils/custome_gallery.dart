// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomGalleryPicker extends StatefulWidget {
  const CustomGalleryPicker({super.key});

  @override
  _CustomGalleryPickerState createState() => _CustomGalleryPickerState();
}

class _CustomGalleryPickerState extends State<CustomGalleryPicker> {
  List<AssetEntity> allAssets = [];
  List<AssetEntity> selectedAssets = [];
  List<File> selectedImageFiles = [];
  Map<AssetEntity, Uint8List> thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (!permission.isAuth) {
      await PhotoManager.openSetting();
      return;
    }

    List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (paths.isNotEmpty) {
      List<AssetEntity> assets = await paths[0].getAssetListPaged(
        page: 0,
        size: 100,
      );

      Map<AssetEntity, Uint8List> thumbMap = {};
      for (AssetEntity asset in assets) {
        final thumb = await asset.thumbnailDataWithSize(
          const ThumbnailSize(200, 200),
        );
        if (thumb != null) {
          thumbMap[asset] = thumb;
        }
      }

      setState(() {
        allAssets = assets;
        thumbnailCache = thumbMap;
      });
    }
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (selectedAssets.contains(asset)) {
        selectedAssets.remove(asset);
      } else {
        if (selectedAssets.length < 10) {
          selectedAssets.add(asset);
        }
      }
    });
  }

  Future<void> _confirmSelection() async {
    List<File> files = [];

    for (final asset in selectedAssets) {
      final file = await asset.file;
      if (file != null) files.add(file);
    }

    setState(() {
      selectedImageFiles = files;
    });

    Navigator.pop(context, selectedImageFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Images (${selectedAssets.length}/10)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmSelection,
          ),
        ],
      ),
      body:
          allAssets.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: allAssets.length,
                itemBuilder: (context, index) {
                  final asset = allAssets[index];
                  final thumb = thumbnailCache[asset];

                  if (thumb == null) {
                    return Container(color: Colors.grey[300]);
                  }

                  return GestureDetector(
                    onTap: () => _toggleSelection(asset),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(thumb, fit: BoxFit.cover),
                        ),
                        if (selectedAssets.contains(asset))
                          const Positioned(
                            right: 4,
                            top: 4,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
