import 'package:elysian_admin/features/entity/chat.dart';
import 'package:flutter/material.dart';

enum MessageStatus { sent, delivered, read, none }

// Data Layer - Repository Implementation
class MessageRepository {
  List<Message> getMessages() {
    return [
      Message(
        id: '1',
        name: 'Sajib Rahman',
        message: 'Hi, John! 👋 How are you doing?',
        time: '09:46',
        avatarUrl: 'assets/avatar1.png',
        isOnline: true,
        status: MessageStatus.none,
      ),
      Message(
        id: '2',
        name: 'Adom Shafi',
        message: 'Typing...',
        time: '08:42',
        avatarUrl: 'assets/avatar2.png',
        isOnline: true,
        isTyping: true,
        status: MessageStatus.delivered,
      ),
      Message(
        id: '3',
        name: 'HR Rumen',
        message: 'You: Cool! 😎 Let\'s meet at 18:00 near the traveling!',
        time: 'Yesterday',
        avatarUrl: 'assets/avatar3.png',
        isOnline: true,
        status: MessageStatus.read,
      ),
      Message(
        id: '4',
        name: 'Anjelina',
        message: 'You: Hey, will you come to the party on Saturday?',
        time: '07:56',
        avatarUrl: 'assets/avatar4.png',
        isOnline: false,
        status: MessageStatus.none,
      ),
      Message(
        id: '5',
        name: 'Alexa Shorna',
        message: 'Thank you for coming! Your or...',
        time: '06:52',
        avatarUrl: 'assets/avatar5.png',
        isOnline: true,
        status: MessageStatus.delivered,
      ),
    ];
  }
}


class ChatPage extends StatelessWidget {
  final MessageRepository repository = MessageRepository();

  ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages = repository.getMessages();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for chats & messages',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageListItem(message: messages[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}

// Presentation Layer - List Item Widget
class MessageListItem extends StatelessWidget {
  final Message message;

  const MessageListItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _getAvatarColor(message.id),
                  child: Text(
                    message.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (message.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          if (message.status != MessageStatus.none)
                            _buildStatusIcon(message.status),
                          const SizedBox(width: 4),
                          Text(
                            message.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.isTyping ? Colors.blue : Colors.grey[600],
                      fontStyle: message.isTyping ? FontStyle.italic : FontStyle.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String id) {
    final colors = [
      Colors.pink[200]!,
      Colors.orange[300]!,
      Colors.purple[300]!,
      Colors.brown[300]!,
      Colors.deepPurple[300]!,
    ];
    return colors[int.parse(id) % colors.length];
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return Icon(Icons.check, size: 16, color: Colors.grey[400]);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 16, color: Colors.grey[400]);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 16, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }
}

