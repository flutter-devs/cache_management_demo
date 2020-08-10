import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cache Manager Demo',
      home: MyHomePage(),
    );
  }
}

const url = 'https://blurha.sh/assets/images/img1.jpg';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<FileResponse> fileStream;

  void _downloadFile() {
    setState(() {
      fileStream = DefaultCacheManager().getFileStream(url, withProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      fileStream = DefaultCacheManager().getFileStream(url, withProgress: true);
    });
    return DownloadPage(
      fileStream: fileStream,
      clearCache: _clearCache,
    );
  }

  void _clearCache() {
    DefaultCacheManager().emptyCache();
    setState(() {
      fileStream = null;
    });
  }
}

class DownloadPage extends StatelessWidget {
  final Stream<FileResponse> fileStream;
  final VoidCallback clearCache;

  const DownloadPage(
      {Key key, this.fileStream, this.clearCache})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: fileStream,
      builder: (context, snapshot) {
        Widget body;

        var loading = !snapshot.hasData || snapshot.data is DownloadProgress;

        if (snapshot.hasError) {
          body = ListTile(
            title: const Text('Error'),
            subtitle: Text(snapshot.error.toString()),
          );
        } else if (loading) {
          body = CircularProgressIndicator();
        } else {
          body = FileInfoWidget(
            fileInfo: snapshot.data as FileInfo,
            clearCache: clearCache,
          );
        }

        return Scaffold(
          appBar: _appBar(),
          body: body,

        );
      },
    );
  }
}

AppBar _appBar() {
  return AppBar(
    leading: CircleAvatar(
      backgroundImage: file != null ? FileImage(file) : AssetImage("name"),
    ),
    title: const Text('Flutter Cache Manager Demo'),
  );
}



File file;

class FileInfoWidget extends StatefulWidget {
  final FileInfo fileInfo;
  final VoidCallback clearCache;

  const FileInfoWidget({Key key, this.fileInfo, this.clearCache})
      : super(key: key);

  @override
  _FileInfoWidgetState createState() => _FileInfoWidgetState();
}

class _FileInfoWidgetState extends State<FileInfoWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.fileInfo.file);
    setState(() {
      file = widget.fileInfo.file;
    });
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Original URL'),
          subtitle: Text(widget.fileInfo.originalUrl),
        ),
        if (widget.fileInfo.file != null)
          ListTile(
            title: const Text('Local file path'),
            subtitle: Text(widget.fileInfo.file.path),
          ),
        ListTile(
          title: const Text('Loaded from'),
          subtitle: Text(widget.fileInfo.source.toString()),
        ),
        ListTile(
          title: const Text('Valid Until'),
          subtitle: Text(widget.fileInfo.validTill.toIso8601String()),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            child: const Text('CLEAR CACHE'),
            onPressed: widget.clearCache,
          ),
        ),
        Image.file(widget.fileInfo.file),
      ],
    );
  }
}
