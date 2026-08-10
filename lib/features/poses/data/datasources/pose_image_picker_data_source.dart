import 'package:image_picker/image_picker.dart';

class PoseImagePickerDataSource {
  PoseImagePickerDataSource({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<String?> pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    return pickedFile?.path;
  }
}
