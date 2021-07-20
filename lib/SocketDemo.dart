import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketDemo extends StatefulWidget {
  const SocketDemo({Key? key}) : super(key: key);

  final String title = 'Socket Demo';

  @override
  _SocketDemoState createState() => _SocketDemoState();
}

class _SocketDemoState extends State<SocketDemo> {
  TextEditingController _textEditingController = TextEditingController();
  WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.org'),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    _connectSocketChannel();
  }

  _connectSocketChannel() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.org'),
    );
  }

  void sendMeesage() {
    _channel.sink.add(_textEditingController.text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(6.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Message',
              ),
            ),
            SizedBox(height: 20.0),
            OutlinedButton(
              onPressed: () {
                if (_textEditingController.text.isEmpty) {
                  return;
                } else {
                  sendMeesage();
                }
              },
              child: Text('send message'),
            ),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
