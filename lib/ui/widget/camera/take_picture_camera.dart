import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/bloc_camera.dart';

class TakePictureCamera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final ResolutionPreset resolutionPreset;
  final bool isEnableVideo;
  final String fileDirectory;

  const TakePictureCamera({
    Key key,
    @required this.cameras,
    this.isEnableVideo: false,
    this.resolutionPreset: ResolutionPreset.max,
    this.fileDirectory,
  })  : assert(isEnableVideo != null),
        assert(cameras != null && cameras.length > 0),
        assert(resolutionPreset != null),
        super(key: key);

  @override
  _TakePictureCameraState createState() => _TakePictureCameraState();
}

class _TakePictureCameraState extends State<TakePictureCamera>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController _controller;
  String _videoPath;

  bool isFrand = false; //是否是前置摄像头

  AnimationController percentageAnimationController;
  bool isShowAnimationView = false;
  BlocCamera _blocCamera;

  @override
  void initState() {
    super.initState();
    _blocCamera = new BlocCamera();
    _blocCamera.setRootPath(widget.fileDirectory);
    WidgetsBinding.instance.addObserver(this);
    //初始化后置摄像头相机
    onNewCameraSelected(widget.cameras.first);

    percentageAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 15000))
      ..addListener(() {
        setState(() {
          if (percentageAnimationController.isCompleted) {
            onStopButtonPressed();
          }
        });
      });
  }

  @override
  void dispose() {
    //用到Controller的话一定要调用其dispose方法释放资源
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    percentageAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        onNewCameraSelected(_controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: Container(
          margin: EdgeInsets.only(top: Utils.topSafeHeight),
          width: Utils.width,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Utils.width,
              maxHeight: Utils.height - Utils.topSafeHeight,
            ),
            //拍照预览
            child: _cameraPreviewWidget(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //选择相册
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () async {
                        File image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          backResult(image.path,
                              isImage: true, isGallery: true);
                        }
                      },
                      icon: Icon(Icons.photo_size_select_actual,
                          color: Colors.white),
                    ),
                  ),
                ),
                //圆点-拍照
                Container(
                  child: CircleAvatar(
                    backgroundColor: Color(0x7fffffff),
                    radius: 36,
                    child: GestureDetector(
                      onTap: () {
                        if (_controller != null &&
                            _controller.value.isInitialized &&
                            !_controller.value.isRecordingVideo) {
                          onTakePictureButtonPressed();
                        }
                      },
                      onLongPressStart: (longStartDetail) {},
                      onLongPressEnd: (longEndDetail) {},
                      onLongPress: () {
                        ///如果不允许录制视频，则长按手势无效果
                        if (!widget.isEnableVideo) {
                          return;
                        }
                        if (_controller != null &&
                            _controller.value.isInitialized &&
                            !_controller.value.isRecordingVideo) {
                          onVideoRecordButtonPressed();
                        }
                      },
                      onLongPressUp: () {
                        ///如果不允许录制视频，则长按手势无效果
                        if (!widget.isEnableVideo) {
                          return;
                        }
                        if (_controller != null &&
                            _controller.value.isInitialized &&
                            _controller.value.isRecordingVideo) {
                          onStopButtonPressed();
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Color(0xffffffff), radius: 30),
                    ),
                  ),
                ),
                //前置和后置摄像头的变换按钮
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        isFrand = !isFrand;
                        if (isFrand) {
                          if (widget.cameras.length > 1) {
                            onNewCameraSelected(widget.cameras[1]);
                          } else {
                            return;
                          }
                        } else {
                          onNewCameraSelected(widget.cameras[0]);
                        }
                      },
                      icon: Icon(Icons.cached, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  ///初始化controller
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    // 要显示摄像机的当前输出
    // 创建一个CameraController
    _controller = CameraController(
      // 从可用摄像头列表中获取特定摄像头
      cameraDescription,
      // 定义要使用的分辨率。
      widget.resolutionPreset,
      //是否录制视频
      enableAudio: widget.isEnableVideo,
    );

    // 设置监听，当controller改变后则改变UI
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      //初始化
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// 配置拍照或录视频的预览界面
  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    } else {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      );
    }
  }

  ///拍照
  void onTakePictureButtonPressed() {
    takePicture().then((String imagePath) {
      if (imagePath == null) {
        return;
      }
      if (mounted) {
        //给返回值，告诉presentingVC返回的是图片以及图片路径
        backResult(imagePath, isImage: true);
      }
    });
  }

  /// 拍照完成返回
  void backResult(String path, {bool isImage: true, bool isGallery: false}) {
    CameraResult cameraResult = CameraResult(path,
        isVideo: !isImage, isImage: isImage, isGallery: isGallery);
    Navigator.pop(context, cameraResult);
  }

  Future<String> takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    String filePath = await _blocCamera.getImagesPath();

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  ///开始录制视频
  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted)
        setState(() {
          percentageAnimationController.forward();
        });
      if (filePath != null) print('Saving video to $filePath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    String filePath = await _blocCamera.getVideoPath();

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      _videoPath = filePath;
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  ///停止录制视频
  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted)
        setState(() {
          percentageAnimationController.reset();
        });
      //视频录制结束,返回结果页
      backResult(_videoPath, isImage: false);
      print('Video recorded to: $_videoPath');
    });
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }

//    await _startVideoPlayer();
  }
}

class CameraResult {
  bool isVideo;
  bool isImage;
  bool isGallery;
  String path;

  CameraResult(this.path,
      {this.isVideo: false, this.isImage: true, this.isGallery: false});
}
