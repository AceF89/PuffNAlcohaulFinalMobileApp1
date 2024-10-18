import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final uuid = const Uuid();
  IOWebSocketChannel? webSocketChannel;

  WebSocketChannel? connectToWS({required String url, required String userId, required String authToken}) {
    webSocketChannel = IOWebSocketChannel.connect(url);
    _sendConnectRequest();
    _sendLoginRequest(userId, authToken);
    return webSocketChannel;
  }

  void _sendConnectRequest() {
    Map msg = {
      "msg": "connect",
      "version": "1",
      "support": ["1", "pre2", "pre1"]
    };
    webSocketChannel?.sink.add(jsonEncode(msg));
  }

  void _sendLoginRequest(String userId, String authToken) {
    Map msg = {
      "msg": "method",
      "method": "login",
      "id": userId,
      "params": [
        {"resume": authToken}
      ]
    };
    webSocketChannel?.sink.add(jsonEncode(msg));
  }

  void sendMessageOnChannel({required String userId, required String roomID, required String message}) {
    Map msg = {
      "msg": "method",
      "method": "sendMessage",
      "id": userId,
      "params": [
        {"rid": roomID, "msg": message}
      ]
    };
    webSocketChannel?.sink.add(jsonEncode(msg));
  }

  void loadHistory({
    required String userId,
    required String roomID,
    int? lastTimestamp,
    required int lastDataTimestamp,
  }) {
    Map msg = {
      "msg": "method",
      "method": "loadHistory",
      "id": userId,
      "params": [
        roomID,
        lastTimestamp,
        200,
        {"\$date": lastDataTimestamp}
      ]
    };
    webSocketChannel?.sink.add(jsonEncode(msg));
  }

  String subscribeRoom({required String roomId}) {
    final subId = uuid.v4();

    Map msg = {
      'msg': 'sub',
      'id': subId,
      'name': 'stream-room-messages',
      'params': [roomId, false]
    };

    webSocketChannel?.sink.add(jsonEncode(msg));

    return subId;
  }

  void unsubscribeRoom({String? subId}) {
    if (subId == null) return;

    Map msg = {
      'msg': 'unsub',
      'id': subId,
    };

    webSocketChannel?.sink.add(jsonEncode(msg));
  }

  void responsePong() {
    Map msg = {"msg": "ping"};
    webSocketChannel?.sink.add(jsonEncode(msg));
  }

/*
  void reconnectToWebSocket(String url, RcAuthentication authentication) {
    // WebSocketChannel? webSocketChannel =
    //     connectToWebSocket(url, authentication);
    // getUserStore(NavigationService.context).changeChannel(webSocketChannel);
    Future.delayed(const Duration(seconds: 5), () {
      // Try to reconnect to the WebSocket after a delay
      WebSocketChannel? webSocketChannel = connectToWebSocket(url, authentication);
      getUserStore(NavigationService.context).changeChannel(webSocketChannel);
    });
  }

  void streamNotifyUserSubscribe(WebSocketChannel webSocketChannel, String userId, String roomID) {
    Map msg = {
      "msg": "sub",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "name": "stream-room-messages",
      "params": [roomID, false]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void createDirectMessage(WebSocketChannel webSocketChannel, String userName) {
    Map msg = {
      "msg": "method",
      "method": "createDirectMessage",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": [userName]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

 

  void readMessage(WebSocketChannel webSocketChannel, String roomID) {
    Map msg = {
      "msg": "method",
      "method": "readMessages",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": [roomID]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

 

  void getLastMessage(WebSocketChannel webSocketChannel, String channelID) {
    Map msg = {
      "msg": "method",
      "method": "rooms/get",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": []
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void streamNotifyRooms(WebSocketChannel webSocketChannel) {
    Map msg = {
      "msg": "method",
      "method": "stream-notify-room",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": ["DyXc9pZsy34qNweRjijmcvaa7EL5KXvD5C/event", false]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void getSubscription(WebSocketChannel webSocketChannel, String channelID) {
    Map msg = {
      "msg": "method",
      "method": "subscriptions/get",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": []
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void setUserStatus(WebSocketChannel webSocketChannel, String channelID, String status) {
    Map msg = {
      "msg": "method",
      "method": "UserPresence:$status",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": []
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void createGroup(WebSocketChannel webSocketChannel, String groupName, List<String> users) {
    Map msg = {
      "msg": "method",
      "method": "createGroup",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": [
        groupName,
        [...users]
      ]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void addUserToGroup(WebSocketChannel webSocketChannel, String groupId, String userName) {
    Map msg = {
      "msg": "method",
      "method": "addUserToGroup",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": [
        {'roomId': groupId, 'username': userName}
      ]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  void removeUserFromGroup(WebSocketChannel webSocketChannel, String groupId, String userName) {
    Map msg = {
      "msg": "method",
      "method": "removeUserFromGroup",
      "id": getUserStore(NavigationService.context).user!.id.toString(),
      "params": [
        {'roomId': groupId, 'username': userName}
      ]
    };
    webSocketChannel.sink.add(jsonEncode(msg));
  }

  
  */
}
