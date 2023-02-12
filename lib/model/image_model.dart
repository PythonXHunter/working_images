import 'package:flutter/services.dart';

class ImageModel1 {
  int? id;
  Uint8List? imageData;

  ImageModel1({this.id, this.imageData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageData': imageData,
    };
  }

  factory ImageModel1.fromMap(Map<String, dynamic> map) {
    return ImageModel1(
      id: map['id'],
      imageData: map['imageData'],
    );
  }
}