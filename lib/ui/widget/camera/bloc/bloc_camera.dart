import 'dart:async';
import 'dart:io';

import '../../../../utils/file_utils.dart';
import '../../../../utils/object_utils.dart';
import 'package:path_provider/path_provider.dart';

class BlocCamera {
  /// 视频和图片根目录->_imagesPath,_videoPath优先级高于_rootPath
  String _rootPath;

  ///图片存放目录
  String _imagesPath;

  /// 视频存放目录
  String _videoPath;

  ///获取时间戳
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> getImagesPath() async {
    if (ObjectUtils.isNotBlank(_imagesPath)) {
      return "$_imagesPath/${timestamp()}.jpg";
    }
    String rootPath = await _getRootPath();
    String dirPath = '$rootPath/Pictures/flutter_bo';
    await Directory(dirPath).create(recursive: true);
    return "$dirPath/${timestamp()}.jpg";
  }

  Future<String> getVideoPath() async {
    if (ObjectUtils.isNotBlank(_videoPath)) {
      return "$_videoPath/${timestamp()}.mp4";
    }
    String rootPath = await _getRootPath();
    String dirPath = '$rootPath/Movies/flutter_bo';
    await Directory(dirPath).create(recursive: true);
    return "$dirPath/${timestamp()}.mp4";
  }

  Future<String> _getRootPath() async {
    if (ObjectUtils.isEmptyString(_rootPath)) {
      Directory directory = await getApplicationDocumentsDirectory();
      _rootPath = directory.path;
    }
    return _rootPath;
  }

  setRootPath(String rootPath) {
    if (ObjectUtils.isNotBlank(rootPath)) {
      this._rootPath = rootPath;
    }
  }

  setImagesPath(String imagesPath) {
    if (ObjectUtils.isNotBlank(imagesPath)) {
      this._imagesPath = FileUtils.getDirectoryPathAndCreate(imagesPath);
    }
  }

  setVideoPath(String videoPath) {
    if (ObjectUtils.isNotBlank(videoPath)) {
      this._videoPath = FileUtils.getDirectoryPathAndCreate(videoPath);
    }
  }
}
