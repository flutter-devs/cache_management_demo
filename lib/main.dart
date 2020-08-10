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

class UploadCacheMemoryData extends StatefulWidget {
  @override
  _UploadCacheMemoryDataState createState() => _UploadCacheMemoryDataState();
}

class _UploadCacheMemoryDataState extends State<UploadCacheMemoryData> {
  @override
  Widget build(BuildContext context) {
    print("UploadCacheMemoryData");
    return StreamBuilder<FileResponse>(
      stream: fileStream,
      builder: (_, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;
        return snapshot.hasData
            ? Image.file(fileInfo.file)
            : Center(
                child: Text("Uploading..."),
              );
      },
    );
  }
}

class FetchCacheMemoryData extends StatefulWidget {
  @override
  _FetchCacheMemoryDataState createState() => _FetchCacheMemoryDataState();
}

class _FetchCacheMemoryDataState extends State<FetchCacheMemoryData> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      fileInfoFuture = DefaultCacheManager().getFileFromCache(url);
    });
    return FutureBuilder(
      future: DefaultCacheManager().getFileFromCache(url),
      builder: (context, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;
        return snapshot.hasData
            ? Image.file(fileInfo.file)
            : Center(child: Text("Fetching..."));
      },
    );
  }
}

Stream<FileResponse> fileStream = DefaultCacheManager().getFileStream(url);
Future<FileInfo> fileInfoFuture = DefaultCacheManager().getFileFromCache(url);
const url = 'https://avatars1.githubusercontent.com/u/41328571?s=280&v=4';
