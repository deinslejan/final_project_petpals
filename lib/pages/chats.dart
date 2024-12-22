import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'userPictures.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;

  const ChatScreen({
    required this.userName,
    required this.userImage,
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  String? currentUserEmail;
  String? receiverEmail;
  String? chatId;

  String? ownerName;
  String? ownerImage;
  bool isOwnerLoading = true;

  @override
  void initState() {
    super.initState();
    currentUserEmail = _auth.currentUser?.email;
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      receiverEmail = await _getReceiverEmail(widget.userName);
      if (receiverEmail != null && currentUserEmail != null) {
        chatId = _generateChatId(currentUserEmail!, receiverEmail!);

        // Fetch owner's details
        await _fetchOwnerDetails(receiverEmail!);
        setState(() {}); // Trigger rebuild with updated details
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing chat: $e')),
      );
    }
  }

  Future<void> _fetchOwnerDetails(String ownerEmail) async {
    try {
      // First check the userProfilePictures map
      var ownerImageFromMap = userProfilePictures[ownerEmail]?['image'];

      if (ownerImageFromMap != null) {
        ownerImage = ownerImageFromMap; // Use the image from the map if available
      } else {
        // If not found in the map, fetch from Firestore
        var ownerSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: ownerEmail)
            .get();

        if (ownerSnapshot.docs.isNotEmpty) {
          var ownerData = ownerSnapshot.docs.first.data();
          ownerName = ((ownerData['firstName'] ?? '').toString().trim()) +
              ' ' +
              ((ownerData['lastName'] ?? '').toString().trim());

          // Fetch the profile picture or use the placeholder image if not available
          ownerImage = ownerData['profilePicture'] ?? 'assets/profile_placeholder.png';
        } else {
          print('No user found with email $ownerEmail');
        }
      }
    } catch (e) {
      print('Error fetching owner details: $e');
      ownerImage = 'assets/profile_placeholder.png'; // Fallback to default image on error
    } finally {
      setState(() {
        isOwnerLoading = false;
      });
    }
  }

  String _generateChatId(String senderEmail, String receiverEmail) {
    List<String> chatIds = [senderEmail, receiverEmail]..sort();
    return chatIds.join('_');
  }

  Future<String?> _getReceiverEmail(String userName) async {
    List<String> nameParts = userName.trim().split(' ');

    if (nameParts.length < 2) {
      print('Invalid userName format: $userName. Expected "FirstName LastName".');
      return null; // Return null instead of throwing an exception
    }

    String firstName = nameParts[0].trim();
    String lastName = nameParts.sublist(1).join(' ').trim(); // Handle multi-word last names

    try {
      var userSnapshot = await _firestore
          .collection('users')
          .where('firstName', isEqualTo: firstName)
          .where('lastName', isEqualTo: lastName)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs.first['email'];
      } else {
        print('No user found for $firstName $lastName.');
        return null;
      }
    } catch (e) {
      print('Error fetching receiver email: $e');
      return null;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || chatId == null) return;

    String messageText = _messageController.text.trim();
    String senderEmail = currentUserEmail!;
    String receiverEmail = this.receiverEmail!;

    try {
      await _firestore.collection('pairs').doc(chatId).set({
        'users': [senderEmail, receiverEmail],
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firestore
          .collection('pairs')
          .doc(chatId)
          .collection('messages')
          .add({
        'message': messageText,
        'sender': senderEmail,
        'receiver': receiverEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  Widget _buildMessageList() {
    if (chatId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('pairs')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No messages yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
        _scrollToBottom();

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index].data() as Map<String, dynamic>;
            bool isSender = message['sender'] == currentUserEmail;

            String timeString = 'Just now';
            if (message['timestamp'] != null) {
              Timestamp timestamp = message['timestamp'] as Timestamp;
              DateTime dateTime = timestamp.toDate();
              timeString = DateFormat('HH:mm').format(dateTime);
            }

            return ChatBubble(
              message: message['message'] as String,
              isSender: isSender,
              timestamp: timeString,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserEmail == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to chat')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B6C),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFFFCA4F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: isOwnerLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : Row(
          children: [
            if (widget.userImage.isNotEmpty)
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userImage),
                radius: 20,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.userName,  // Displaying the passed userName directly
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bebas Neue',
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          ChatInput(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String timestamp;

  const ChatBubble({
    required this.message,
    required this.isSender,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSender ? Colors.white : const Color(0xFFFFCA4F),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: Radius.circular(isSender ? 15 : 0),
              bottomRight: Radius.circular(isSender ? 0 : 15),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isSender ? Colors.black : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            timestamp,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    required this.controller,
    required this.onSend,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Send a pawesome message!",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA4F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.send, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}