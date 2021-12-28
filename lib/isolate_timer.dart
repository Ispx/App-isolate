import 'dart:async';
import 'dart:isolate';

class IsolateTimer {
  final ReceivePort _receivePort = ReceivePort();
  Isolate? _isolate;
  ReceivePort? get receivePort => _receivePort;
  Future<void> createIsolate() async {
    try {
      _isolate?.kill();
      _isolate = await Isolate.spawn<SendPort>(_timer, _receivePort.sendPort);
    } catch (e) {
      print(e.toString());
      throw "Falha ao criar isolate: " + e.toString();
    }
  }

  static void _timer(SendPort sendPort) {
    sendPort.send(DateTime.now());
  }

  void close() {
    _isolate?.kill();
    _receivePort.close();
  }
}
