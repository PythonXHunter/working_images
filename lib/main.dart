import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_sqflite/model/image_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'helper/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  final picker = ImagePicker();
  List<ImageModel1> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    List<ImageModel1> images = await DatabaseHelper.getImages();
    setState(() {
      _images = images;
    });
  }

  void _addImage(File file) async {
    Uint8List imageData = await file.readAsBytes();
    ImageModel1 image = ImageModel1(imageData: imageData);
    await dbHelper.insertImage(image);
    _loadImages();
  }

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _addImage(File(pickedFile.path));
    }
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      _addImage(File(result.files.single.path!));
    }
  }

  void _deleteImage(int id) async {
    await dbHelper.deleteImage(id);
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Demo'),
      ),
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          return ListTile(
            leading: Image.memory(image.imageData!),
            title: Text('Image ${image.id}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteImage(image.id!);
              },
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _pickImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.photo),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _pickFile,
            tooltip: 'Pick File',
            child: Icon(Icons.attach_file),
          ),
        ],
      ),
    );
  }
}
