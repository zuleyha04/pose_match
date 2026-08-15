import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:pose_match/features/camera/data/models/device_camera_model.dart';

abstract class CameraLocalDataSource {
  Future<List<DeviceCameraModel>> getAvailableCameras();
  Future<void> savePhotoToGallery(String photoPath);
}

class CameraLocalDataSourceImpl implements CameraLocalDataSource {
  @override
  Future<List<DeviceCameraModel>> getAvailableCameras() async {
    final cameras = await availableCameras();

    return cameras
        .map(DeviceCameraModel.fromCameraDescription)
        .toList(growable: false);
  }

  @override
  Future<void> savePhotoToGallery(String photoPath) async {
    final file = File(photoPath);

    debugPrint('SOURCE PATH: $photoPath');
    debugPrint('SOURCE EXISTS: ${await file.exists()}');
    debugPrint('SOURCE SIZE: ${await file.length()}');

    final hasAccess = await Gal.hasAccess();
    debugPrint('GAL ACCESS: $hasAccess');

    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      debugPrint('GAL PERMISSION: $granted');

      if (!granted) {
        throw Exception('Gallery permission denied');
      }
    }

    try {
      await Gal.putImage(photoPath, album: 'PoseMatch');

      debugPrint('GAL PUT IMAGE COMPLETED');
    } on GalException catch (error, stackTrace) {
      debugPrint('GAL ERROR TYPE: ${error.type}');
      debugPrint('GAL ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }
}
