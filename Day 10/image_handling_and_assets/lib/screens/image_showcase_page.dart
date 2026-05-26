import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/gallery_entry.dart';
import '../widgets/cached_network_image_card.dart';
import '../widgets/gallery_grid.dart';
import '../widgets/image_fit_controls.dart';
import '../widgets/image_frame.dart';
import '../widgets/section_card.dart';
import 'image_viewer_page.dart';

class ImageShowcasePage extends StatefulWidget {
  const ImageShowcasePage({super.key});

  @override
  State<ImageShowcasePage> createState() => _ImageShowcasePageState();
}

class _ImageShowcasePageState extends State<ImageShowcasePage> {
  static const String _assetImagePath = 'assets/images/sample_asset.png';

  final ImagePicker _picker = ImagePicker();
  final List<String> _networkImages = <String>[
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=1200',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1200',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=1200',
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=1200',
  ];

  String _selectedNetworkImage =
      'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=1200';
  BoxFit _selectedBoxFit = BoxFit.cover;
  double _previewWidth = 260;
  bool _isUploading = false;

  File? _pickedImage;
  File? _profileImage;
  File? _filteredImage;
  final List<File> _localGallery = <File>[];

  Future<void> _pickImage({
    required ImageSource source,
    bool forProfile = false,
  }) async {
    try {
      final XFile? xFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1800,
      );

      if (xFile == null) {
        return;
      }

      final File file = File(xFile.path);
      setState(() {
        if (forProfile) {
          _profileImage = file;
        } else {
          _pickedImage = file;
          _localGallery.insert(0, file);
        }
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Permission error: ${error.message ?? 'Please allow camera/photos access in device settings.'}',
          ),
        ),
      );
    }
  }

  Future<void> _applyGrayscaleFilter() async {
    if (_pickedImage == null) {
      return;
    }

    final bytes = await _pickedImage!.readAsBytes();
    final imglib.Image? decoded = imglib.decodeImage(bytes);
    if (decoded == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to decode image for filtering.')),
      );
      return;
    }

    final imglib.Image grayscale = imglib.grayscale(decoded);
    final imglib.Image resized = imglib.copyResize(
      grayscale,
      width: grayscale.width > 1200 ? 1200 : grayscale.width,
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String fileName =
        'filtered_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File outputFile = File('${tempDir.path}/$fileName');
    await outputFile.writeAsBytes(imglib.encodeJpg(resized, quality: 88));

    setState(() {
      _filteredImage = outputFile;
      _localGallery.insert(0, outputFile);
    });
  }

  Future<void> _previewAndUpload() async {
    final File? imageToUpload = _profileImage ?? _pickedImage;
    if (imageToUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a profile image before uploading.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Upload Preview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ImageFrame(
                width: 160,
                height: 160,
                child: Image.file(imageToUpload, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  setState(() {
                    _isUploading = true;
                  });

                  await Future<void>.delayed(const Duration(seconds: 2));
                  if (!mounted) {
                    return;
                  }

                  setState(() {
                    _isUploading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile image uploaded successfully.'),
                    ),
                  );
                },
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Confirm Upload'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openImageViewer({
    required ImageProvider provider,
    required String title,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ImageViewerPage(title: title, imageProvider: provider),
      ),
    );
  }

  List<GalleryEntry> _buildGalleryEntries() {
    return <GalleryEntry>[
      ..._networkImages.map(
        (String url) => GalleryEntry(
          title: 'Network',
          provider: CachedNetworkImageProvider(url),
          source: GalleryEntrySource.network,
        ),
      ),
      ..._localGallery.map(
        (File file) => GalleryEntry(
          title: 'Local',
          provider: FileImage(file),
          source: GalleryEntrySource.local,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Image Handling Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionCard(
              title: 'Asset Images + BoxFit',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImageFitControls(
                    selectedBoxFit: _selectedBoxFit,
                    previewWidth: _previewWidth,
                    onBoxFitChanged: (BoxFit fit) {
                      setState(() {
                        _selectedBoxFit = fit;
                      });
                    },
                    onPreviewWidthChanged: (double value) {
                      setState(() {
                        _previewWidth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ImageFrame(
                    width: _previewWidth,
                    height: 180,
                    child: Image.asset(_assetImagePath, fit: _selectedBoxFit),
                  ),
                ],
              ),
            ),
            SectionCard(
              title: 'Network Images + Caching',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton<String>(
                    value: _selectedNetworkImage,
                    isExpanded: true,
                    items: _networkImages
                        .map(
                          (String url) => DropdownMenuItem<String>(
                            value: url,
                            child: Text(
                              url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedNetworkImage = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  CachedNetworkImageCard(
                    imageUrl: _selectedNetworkImage,
                    width: _previewWidth,
                    height: 180,
                    fit: _selectedBoxFit,
                  ),
                ],
              ),
            ),
            SectionCard(
              title: 'Image Picker: Gallery + Camera',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () =>
                            _pickImage(source: ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Pick From Gallery'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _pickImage(source: ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Take Photo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_pickedImage != null)
                    ImageFrame(
                      width: _previewWidth,
                      height: 180,
                      child: Image.file(_pickedImage!, fit: _selectedBoxFit),
                    )
                  else
                    const Text('Pick an image to preview it here.'),
                ],
              ),
            ),
            SectionCard(
              title: 'Image Transformations (Resize + Filter)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Resize is controlled by the width slider above.'),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _pickedImage == null
                        ? null
                        : _applyGrayscaleFilter,
                    icon: const Icon(Icons.filter_b_and_w_outlined),
                    label: const Text('Apply Grayscale Filter (Bonus)'),
                  ),
                  if (_filteredImage != null) ...<Widget>[
                    const SizedBox(height: 10),
                    ImageFrame(
                      width: _previewWidth,
                      height: 180,
                      child: Image.file(_filteredImage!, fit: _selectedBoxFit),
                    ),
                  ],
                ],
              ),
            ),
            SectionCard(
              title: 'Profile Upload Flow',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.person_outline, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            OutlinedButton(
                              onPressed: () => _pickImage(
                                source: ImageSource.gallery,
                                forProfile: true,
                              ),
                              child: const Text('Gallery'),
                            ),
                            OutlinedButton(
                              onPressed: () => _pickImage(
                                source: ImageSource.camera,
                                forProfile: true,
                              ),
                              child: const Text('Camera'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: _isUploading ? null : _previewAndUpload,
                    icon: _isUploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file_outlined),
                    label: Text(
                      _isUploading ? 'Uploading...' : 'Preview Before Upload',
                    ),
                  ),
                ],
              ),
            ),
            SectionCard(
              title: 'Gallery Grid + Zoom Viewer',
              child: GalleryGrid(
                entries: _buildGalleryEntries(),
                onTapEntry: (GalleryEntry entry) {
                  final String kindLabel =
                      entry.source == GalleryEntrySource.network
                      ? 'Image'
                      : 'Photo';
                  _openImageViewer(
                    provider: entry.provider,
                    title: '${entry.title} $kindLabel',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
