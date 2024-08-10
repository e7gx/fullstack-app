import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/services/api_service.dart';
import 'package:todoapp/services/shared_preferences_service.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:flutter/services.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _MainPageState();
}

class _MainPageState extends State<AiChatPage> {
  final List<Message> _messages = [];
  String _firstName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _saveChatHistory() async {
    List<String> messages = _messages
        .map((message) => json.encode({
              'text': message.text,
              'isMe': message.isMe,
            }))
        .toList();

    await SharedPreferencesService.saveChatHistory(messages);
  }

  Future<void> _loadUserData() async {
    final firstName = await SharedPreferencesService.getFirstName();
    final chatHistory = await SharedPreferencesService.getChatHistory();

    setState(() {
      _firstName = firstName;
      if (chatHistory.isNotEmpty) {
        _messages.addAll(chatHistory.map((message) {
          final parsed = json.decode(message);
          return Message(text: parsed['text'], isMe: parsed['isMe']);
        }).toList());
      }
    });
  }

  final TextEditingController _textEditingController = TextEditingController();

  bool _userSentMessage = false;

  void onSendMessage() {
    String trimmedText = _textEditingController.text.trim();
    if (trimmedText.isEmpty) {
      return;
    }

    setState(() {
      _userSentMessage = true;
      Message message = Message(text: trimmedText, isMe: true);
      _messages.insert(0, message);
      _textEditingController.clear();
    });

    _saveChatHistory(); // Save after sending the message

    sendMessageToChatGpt(trimmedText).then((response) {
      Message chatGptMessage = Message(text: response, isMe: false);
      setState(() {
        _messages.insert(0, chatGptMessage);
      });
      _saveChatHistory(); // Save after receiving the response
    }).catchError((error) {
      // Handle the error here
    });
  }

  Future<String> sendMessageToChatGpt(String message) async {
    try {
      // Fetch the list of to-do items
      List<Todo> todosList = await ApiService().fetchTodos();

      // Convert the list of Todos to a string
      String formattedTodosList = todosList
          .map((todo) =>
              '- ${todo.title}\n  Description: ${todo.description}\n  Done: ${todo.done ? 'Yes' : 'No'}') // Assuming each Todo has 'title', 'description', and 'done' properties
          .join('\n');

      // Define the prompt
      String prompt = """
    You are an helpful assistant in a to-do list app. Here's the current list of tasks:
    $formattedTodosList
    
    If the user didn't has any tasks, say: "You don't have any tasks yet."

    Based on the user's input, respond within the context of task management and productivity.

    If the user asks for help, provide a list of commands they can use.

    If the user asks for his tasks or todos provide a list of his todos or tasks.
    
    """;

      // Concatenate the prompt with the user's message
      String promptMessage = "$prompt\nUser's Message: $message";

      // Define the API endpoint and body
      Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");
      Map<String, dynamic> body = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": promptMessage}
        ],
        "max_tokens": 250,
      };

      // Send the HTTP POST request
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer ${APIKey.apikey}",
        },
        body: json.encode(body),
      );

      // Parse the response
      if (response.statusCode == 200) {
        Map<String, dynamic> parsedResponse =
            json.decode(utf8.decode(response.bodyBytes));
        if (parsedResponse.containsKey('choices') &&
            parsedResponse['choices'].isNotEmpty &&
            parsedResponse['choices'][0].containsKey('message')) {
          String content = parsedResponse['choices'][0]['message']['content'] ??
              "No reply found.";
          return content;
        } else {
          return "Error: Invalid response format.";
        }
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: Exception during API call.";
    }
  }

  Widget _buildMessage(Message message, bool isLatestMessage) {
    // تحديد مسار صورة المتحدث
    String imagePath =
        message.isMe ? 'assets/images/image.jpg' : 'assets/images/ai.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) // لعرض صورة الـ AI قبل الرسالة
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: message.isMe
                  ? SelectableText(
                      message.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Cario', // استخدام الخط Cario هنا
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : isLatestMessage
                      // ignore: deprecated_member_use
                      ? TypeWriterText(
                          text: Text(
                            message.text,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Cario', // استخدام الخط Cario هنا
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          duration: const Duration(
                              milliseconds: 5), // تحديد سرعة الكتابة هنا
                        )
                      : Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Cario', // استخدام الخط Cario هنا
                            fontWeight: FontWeight.bold,
                          ),
                        ),
            ),
          ),
          if (message.isMe) // لعرض صورة المستخدم بعد الرسالة
            const SizedBox(width: 6),
          if (message.isMe)
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
            ),
        ],
      ),
    );
  }

//! KEYBOARD STYLE HERE //!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFFFFFFF),
              Colors.grey,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(
            children: <Widget>[
              // Add the explanatory message here
              if (!_userSentMessage) _buildWelcomeMessage(),

              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isLatestMessage =
                        index == 0; // Check if it's the latest message
                    return _buildMessage(_messages[index], isLatestMessage);
                  },
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.white,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Divider(height: 4.0),
              ),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          hintText: "hello...",
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            // Allow newValue if it's empty or doesn't start with a space
                            if (newValue.text.isEmpty ||
                                newValue.text[0] != ' ') {
                              return newValue;
                            }
                            // Otherwise, return oldValue to prevent adding the space at the beginning
                            return oldValue;
                          }),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onSendMessage,
                      icon: const Icon(
                        Icons.rocket_launch,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    if (!_userSentMessage && _textEditingController.text.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Hello $_firstName, How can I help you today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.teal[900],
                  fontSize: 16,
                  fontFamily: 'Cario', // استخدام الخط Cario هنا
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Lottie.asset(
              'assets/animation/like1.json',
              fit: BoxFit.fitWidth,
              height: 50,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(); // يعود بعرض مربع فارغ بدون أي شيء
    }
  }
}

class Message {
  final String text;
  final bool isMe;
  Message({required this.text, required this.isMe});
}

class APIKey {
  static final apikey = dotenv.env['OPENAI_API_KEY'];
}
