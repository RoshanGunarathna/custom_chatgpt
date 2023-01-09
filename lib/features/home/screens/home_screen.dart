import 'package:avatar_glow/avatar_glow.dart';
import 'package:custom_chatgpt/common/widgets/appbar_menu.dart';
import 'package:custom_chatgpt/constants/colors.dart';
import 'package:custom_chatgpt/features/home/services/voice_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../common/player.dart';
import '../../../common/show_snackbar.dart';
import '../../../models/chat_model.dart';
import '../services/ai_services.dart';
import '../widgets/my_message_card.dart';
import '../widgets/sender_message_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isVoiceSupport = false;
  String _text = "Say something!";
  bool _isListening = false;
  final List<ChatMessage> _messages = [];

  //instants
  SpeechToText _speechToText = SpeechToText();
  TextEditingController _myMsgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiServices _aiServices = AiServices();
  final VoiceServices _voiceServices = VoiceServices();

  //check phone is voice supported or not
  void voiceSupportCheck() async {
    try {
      var available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isVoiceSupport = true;
        });
      }
    } catch (e) {
      print(e);
      showSnackBar(context, 'Voice recognitions is not support your phone.');
    }
  }

  autoScrollMethod() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    voiceSupportCheck();
  }

  @override
  void dispose() {
    super.dispose();
    _myMsgController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(_text),
        centerTitle: false,
        actions: [
          const AppBarMenu(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                ChatMessage chat = _messages[index];
                if (chat.type == ChatMessageType.user) {
                  return MyMessageCard(
                    message: chat.text.toString(),
                    date: DateFormat.jm().format(DateTime.now()),
                  );
                }
                return SenderMessageCard(
                  message: chat.text,
                  date: DateFormat.jm().format(DateTime.now()),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  cursorColor: primaryColor,
                  controller: _myMsgController,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: primaryColor),
                      labelText: _isVoiceSupport
                          ? 'Type here or speak.....'
                          : 'Type here....',
                      contentPadding: const EdgeInsets.only(left: 10)),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (_myMsgController.text.isNotEmpty) {
                    setState(() {
                      _text = _myMsgController.text;
                      _myMsgController.text = '';
                    });

                    //add user msg to chat list
                    _messages.add(
                        ChatMessage(text: _text, type: ChatMessageType.user));
                    FocusManager.instance.primaryFocus?.unfocus();
                    autoScrollMethod();

                    //sent to ai
                    String? msg = await _aiServices.sendMsgToAi(
                        context: context, msg: _text);

                    //get voice
                    if (msg != null) {
                      if (msg.isNotEmpty) {
                        _voiceServices.requestVoice(
                            context: context, voiceType: "en-US-1", text: msg);
                      }
                    } else {
                      showSnackBar(context, 'My voice is gone');
                    }

                    //add ai msg to chat list
                    if (msg != null) {
                      setState(() {
                        _messages.add(
                            ChatMessage(text: msg, type: ChatMessageType.bot));
                      });
                      autoScrollMethod();
                    }
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: appBarColor,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isVoiceSupport
          ? AvatarGlow(
              glowColor: appBarColor,
              repeat: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              showTwoGlows: true,
              endRadius: 75.0,
              animate: _isListening,
              duration: const Duration(milliseconds: 2000),
              child: GestureDetector(
                onTapDown: (details) async {
                  Play.assetPlayer('assets/sounds/voice_in.mp3');
                  if (!_isListening) {
                    setState(() {
                      _isListening = true;
                    });
                    var available = await _speechToText.initialize();
                    if (available) {
                      setState(() {
                        _speechToText.listen(
                          onResult: (result) {
                            setState(() {
                              _text = result.recognizedWords;
                            });
                          },
                        );
                      });
                    }
                  }
                },
                onTapUp: (details) async {
                  Play.assetPlayer('assets/sounds/voice_out.mp3');
                  setState(() {
                    _isListening = false;
                  });
                  _speechToText.stop();

                  //add user msg to the list
                  _messages.add(
                      ChatMessage(text: _text, type: ChatMessageType.user));

                  //send to ai
                  String? aiMsg = await _aiServices.sendMsgToAi(
                      context: context, msg: _text);

                  //get voice
                  if (aiMsg != null) {
                    if (aiMsg.isNotEmpty) {
                      _voiceServices.requestVoice(
                          context: context, voiceType: "en-US-1", text: aiMsg);
                    }
                  } else {
                    showSnackBar(context, 'My voice is gone');
                  }

                  //add ai msg to chat list
                  if (aiMsg != null) {
                    setState(() {
                      _messages.add(
                          ChatMessage(text: aiMsg, type: ChatMessageType.bot));
                    });
                  }
                  autoScrollMethod();
                },
                child: CircleAvatar(
                  backgroundColor: appBarColor.withOpacity(0.2),
                  radius: 35,
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
