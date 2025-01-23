import 'dart:convert';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/model/rc/rc_message.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/services/web_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final AutoDisposeChangeNotifierProvider<ChatProvider> chatProvider =
ChangeNotifierProvider.autoDispose((ref) => ChatProvider());

class ChatProvider extends DefaultChangeNotifier {
  Order? currentChatOrder;
  WebSocketChannel? channel;
  String? roomSubscriptionId;
  WebSocketService wsService = WebSocketService();
  bool _isConnected = false;
  List<RcMessage> chatMessages = [];
  final TextEditingController chatController = TextEditingController();

  ChatProvider();

  @override
  void dispose() {
    wsService.unsubscribeRoom(subId: roomSubscriptionId);
    channel?.sink.close();
    super.dispose();
  }

  void initChat({required Order order}) {
    currentChatOrder = order;

    final chatRoomId = currentChatOrder?.rcChannelId ?? '';

    const url = EnvValues.rcSocketUrl;
    final userId = preferences.getUserProfile()?.rcUserId ?? '';
    final authToken = preferences.getUserProfile()?.chatToken ?? '';

    channel =
        wsService.connectToWS(url: url, userId: userId, authToken: authToken);
    _isConnected = true;
    // check if channel is connected
    if (channel == null) {
      initChat(order: order);
      return;
    }

    channel?.stream.listen(
          (event) {
        final Map<String, dynamic> decodedEvent = jsonDecode(event);

        /// Handle Result
        if (decodedEvent["msg"] == "result" ||
            decodedEvent["msg"] == "changed") {
          handleChatMessages(decodedEvent);
        }

        /// TO Maintain Connection
        if (decodedEvent["msg"] == "ping") {
          wsService.responsePong();
        }
      },
      onDone: () {
        _isConnected = false;
      },
      onError: (error) {
        debugPrint('ws error $error');
        _isConnected = false;
      },
    );

    roomSubscriptionId = wsService.subscribeRoom(roomId: chatRoomId);

    wsService.loadHistory(
      userId: userId,
      roomID: chatRoomId,
      lastDataTimestamp: DateTime.now().millisecondsSinceEpoch - 600000,
    );
  }

  Future<void> ensureConnection() async {
    while (!await ConnectivityService.isConnected || !_isConnected) {
      initChat(order: currentChatOrder!);
      // Allow some time for reconnection
      await Future.delayed(const Duration(seconds: 1));
      if (_isConnected) {
        // handleOnSendMessage(context);
        break;
      }
    }
  }

  Future<void> handleOnSendMessage(BuildContext context) async {
    // check socket connection
    await ensureConnection();
    if (chatController.text.trim().isEmpty) {
      context.showFailureSnackBar('Please enter a message');
      return;
    }
    wsService.sendMessageOnChannel(
      message: chatController.text.trim(),
      roomID: currentChatOrder?.rcChannelId ?? '',
      userId: preferences.getUserProfile()?.rcUserId ?? '',
    );
    chatController.clear();
  }

  void handleChatMessages(Map<String, dynamic>? event) {
    if (event == null) return;

    if (event.containsKey('result')) {
      /// Load History
      if (event['result'].containsKey('messages')) {
        final messageList = event['result']['messages'] as List<dynamic>;
        for (final element in messageList) {
          final message = RcMessage(
            id: element['_id'],
            userId: element['u']['_id'],
            username: element['u']['username'],
            userFullName: element['u']['name'],
            msg: element['msg'],
            createdAt:
            DateTime.fromMillisecondsSinceEpoch(element['ts']['\$date']),
          );
          chatMessages.add(message);
        }
        notify();
        return;
      }

      /// Sent Message Response
      // if (event['result'].containsKey('msg')) {
      //   final rawMessage = event['result'];

      //   final message = RcMessage(
      //     id: rawMessage['_id'],
      //     userId: rawMessage['u']['_id'],
      //     username: rawMessage['u']['username'],
      //     userFullName: rawMessage['u']['name'],
      //     msg: rawMessage['msg'],
      //     createdAt: DateTime.fromMillisecondsSinceEpoch(rawMessage['ts']['\$date']),
      //   );
      //   chatMessages.insert(0, message);
      //   notify();
      //   return;
      // }
    }

    if (event.containsKey('fields')) {
      final rawMessage = event['fields']['args'];
      for (final element in rawMessage) {
        final message = RcMessage(
          id: element['_id'],
          userId: element['u']['_id'],
          username: element['u']['username'],
          userFullName: element['u']['name'],
          msg: element['msg'],
          createdAt:
          DateTime.fromMillisecondsSinceEpoch(element['ts']['\$date']),
        );
        chatMessages.insert(0, message);
      }
      notify();
      return;
    }
  }
}
