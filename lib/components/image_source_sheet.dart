import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({Key key, this.onImageSelected, this.onImageDeleted})
      : super(key: key);

  final Function(File) onImageSelected;
  final Function onImageDeleted;
  final ImagePicker _picker = ImagePicker();

  Future<void> editImage(String path, BuildContext context) async {
    final File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        // aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.circle,
        compressQuality: 50,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Editar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',
        ));
    if (croppedFile != null) {
      onImageSelected(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              final XFile photo = await _picker.pickImage(
                source: ImageSource.camera,
              );
              //onImageSelected(File(photo.path));
              editImage(photo.path, context);
            },
            child: const Text('Câmera'),
          ),
          FlatButton(
            onPressed: () async {
              final XFile image = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              // onImageSelected(File(image.path));
              editImage(image.path, context);
            },
            child: const Text('Galeria'),
          ),
          FlatButton(
            onPressed: () {
              onImageDeleted();
            },
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
