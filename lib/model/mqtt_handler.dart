import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler {
  final MqttServerClient client;
  final ValueNotifier<String> statusNotifier
  = ValueNotifier<String>('Disconnected');

  final ValueNotifier<List<Map<String, dynamic>>> messageLog
  = ValueNotifier<List<Map<String, dynamic>>>([]);

  final Logger _logger = Logger();

  MqttHandler() : client = MqttServerClient(
      'broker.hivemq.com',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
  ) {
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.pongCallback = _pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime
        .now().millisecondsSinceEpoch}')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;
  }

  Future<void> connect() async {
    try {
      statusNotifier.value = 'Connecting...';
      await client.connect();
    } catch (e) {
      statusNotifier.value = 'Connection failed: $e';
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      statusNotifier.value = 'Connected';
    } else {
      statusNotifier.value =
      'Connection failed: ${client.connectionStatus!.state}';

      client.disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void _onConnected() {
    statusNotifier.value = 'Connected';
  }

  void _onDisconnected() {
    statusNotifier.value = 'Disconnected';
  }

  void _onSubscribed(String topic) {
    _logger.d('Subscribed to topic: $topic');
  }

  void _pong() {
    _logger.d('Ping response client callback invoked');
  }

  void listenForMessages(void Function(Map<String, dynamic>) callback) {
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload
          .bytesToStringAsString(message.payload.message);

      try {
        final dynamic decoded = json.decode(payload);

        if (decoded is List) {
          for (var item in decoded) {
            if (item is Map<String, dynamic>) {
              messageLog.value = [...messageLog.value, item];
              callback(item);
            }
          }
        } else if (decoded is Map<String, dynamic>) {
          messageLog.value = [...messageLog.value, decoded];
          callback(decoded);
        }
      } catch (e) {
        _logger.e('Error parsing message: $e');
      }
    });
  }
}
