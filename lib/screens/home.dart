import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lg_kiss_app/services/action_service.dart';
import 'package:lg_kiss_app/widgets/navbar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../services/gemma_service.dart';
class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {  
    GroqService _gemma=GroqService();
    late stt.SpeechToText _speech;
    bool _isListening=false;
      @override
  void initState(){
    super.initState();
    _speech=stt.SpeechToText();
    _gemma.init();
  }
    final ScrollController _scrollController=ScrollController();
    String _text="Press the button and talk to the Liquid Galaxy";
    void _listen()async{
      var micStatus = await Permission.microphone.request();
      if (micStatus.isDenied || micStatus.isPermanentlyDenied) {
       openAppSettings();
        return;
        }
      if(!_isListening){
        bool available=await _speech.initialize(
          onStatus: (val) async {print('onStatus :$val');
          if(val=='done'){final response=await _gemma.sendGemma(_text);
          handleAIResponse(jsonDecode(response!));
          }},
          onError: (val)=>print('onError :$val'),
        );
        if (available){
          setState(() {
            _isListening=true;
          });
          _speech.listen(
            onResult: (val)=>setState(() {
              print(val.recognizedWords);
              _text=val.recognizedWords;

            }),
          listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.dictation,
            partialResults: true
          )
          );
        }
      }else{
        setState(() {
          _isListening=false;
          
        });
        _speech.stop();
        
      }
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Navbar(selectedIndex: 0),
      body:
         Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left:20,right:20),
                height: 150,
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    reverse: true,
                    controller: _scrollController,
                    child: Text(_text,overflow: TextOverflow.clip,)),
                )),
              Container(
                margin: EdgeInsets.all(20),
                width: 100,
                height: 100,
                child: Ink(
                        decoration: const ShapeDecoration(color: Colors.lightBlue, shape: CircleBorder(
                        )),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () async {_listen();},
                    icon: Icon(Icons.mic)),
                ),
              ),
            ],
          ),
        )
      
      
    );
  }}