import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            actions: [
              FlatButton(
                  onPressed: () {
                    DefaultCacheManager().emptyCache();
                    setState(() {
                      fileInfoFuture = null;
                    });
                  },
                  child: Text("Clear cache"))
            ],
            title: Text("Cache memory demo"),
          ),
          body: fileInfoFuture == null
              ? UploadCacheMemoryData()
              : FetchCacheMemoryData()),
    );
  }
}

class UploadCacheMemoryData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("UploadCacheMemoryData");
    return StreamBuilder<FileResponse>(
      stream: fileStream,
      builder: (_, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;
        return snapshot.hasData
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.file(fileInfo.file),
                  Text("Original Url:${fileInfo.originalUrl}"),
                  Text("Valid Till:${fileInfo.validTill}"),
                  Text("File address:${fileInfo.file}"),
                  Text("File source:${fileInfo.source}"),
                  Text("Hash code:${fileInfo.hashCode}"),
                  Text("Hash code:${fileInfo.runtimeType}"),
                ],
              )
            : Center(
                child: Text("Uploading..."),
              );
      },
    );
  }
}

class FetchCacheMemoryData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("FetchCacheMemoryData");
    return FutureBuilder(
      future:fileInfoFuture,
      builder: (context, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;
        return snapshot.hasData
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.file(fileInfo.file),
                  Text("Original Url:${fileInfo.originalUrl}"),
                  Text("Valid Till:${fileInfo.validTill}"),
                  Text("File address:${fileInfo.file}"),
                  Text("File source:${fileInfo.source}"),
                  Text("Hash code:${fileInfo.hashCode}"),
                  Text("Hash code:${fileInfo.runtimeType}"),
                ],
              )
            : Center(child: Text("Fetching..."));
      },
    );
  }
}

Stream<FileResponse> fileStream = DefaultCacheManager().getFileStream(url);
Future<FileInfo> fileInfoFuture = DefaultCacheManager().getFileFromCache(url);
const url = 'https://avatars1.githubusercontent.com/u/41328571?s=280&v=4';
