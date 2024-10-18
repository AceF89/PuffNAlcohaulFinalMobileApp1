import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/views/screens/chats/provider/chat_provider.dart';
import 'package:alcoholdeliver/views/screens/chats/widget/chat_app_bar.dart';
import 'package:alcoholdeliver/views/screens/chats/widget/chat_bottom_bar.dart';
import 'package:alcoholdeliver/views/screens/chats/widget/chat_text_tile.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends StatefulWidget {
  final Order order;

  const ChatScreen({super.key, required this.order});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatProvider _provider;
  final rcUserId = preferences.getUserProfile()?.rcUserId ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initChat(order: widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SizedBox(
            height: Sizes.s20.h,
            width: Sizes.s20.h,
            child: const Padding(
              padding: EdgeInsets.only(
                left: Sizes.s20,
                top: Sizes.s10,
                bottom: Sizes.s10,
              ),
              child: IconContainer(
                icon: AppAssets.icBackArrow,
              ),
            ),
          ),
        ),
        title: ChatAppBar(
          customerName: widget.order.placedByName ?? 'N/A',
          driverName: widget.order.driverName ?? 'N/A',
          isDriver: preferences.isDriver,
        ),
      ),
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(chatProvider);

        return Column(
          children: [
            /// Chat Tile
            Expanded(
              child: ListView.builder(
                itemCount: _provider.chatMessages.length,
                reverse: true,
                padding: EdgeInsets.all(PaddingValues.padding.h),
                itemBuilder: (ctx, i) {
                  final curChat = _provider.chatMessages[i];
                  return ChatTextTile(
                    isLoggedInUser: curChat.userId == rcUserId,
                    message: curChat,
                  );
                },
              ),
            ),

            /// Chat Keyboard
            ChatBottomBar(
              onTap: _provider.handleOnSendMessage,
              controller: _provider.chatController,
            ),
          ],
        );
      }),
    );
  }
}
