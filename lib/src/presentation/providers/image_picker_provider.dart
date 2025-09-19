import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;

  File? get selectedImage => _selectedImage;
  bool get hasImage => _selectedImage != null;
  String? get imagePath => _selectedImage?.path;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setImage(File? image) {
    _selectedImage = image;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    try {
      _setLoading(true);
      _setError(null);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        _setImage(File(pickedFile.path));
      }
    } catch (e) {
      _setError('Error al seleccionar imagen de la galería: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      _setLoading(true);
      _setError(null);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        _setImage(File(pickedFile.path));
      }
    } catch (e) {
      _setError('Error al tomar foto con la cámara: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void removeImage() {
    _setImage(null);
    _setError(null);
  }

  void clearError() {
    _setError(null);
  }
}
