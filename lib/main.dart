import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        webSocketChannel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.webSocketChannel})
      : super(key: key);
  final WebSocketChannel webSocketChannel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Socket'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
               TextField(
                controller: textEditingController,
              ),
              StreamBuilder(
                  stream: widget.webSocketChannel.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Text('${snapshot.data}');
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error_outline);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      widget.webSocketChannel.sink.add(textEditingController.text);
    }
  }

  @override
  void dispose() {
    widget.webSocketChannel.sink.close();
    super.dispose();
  }
}
