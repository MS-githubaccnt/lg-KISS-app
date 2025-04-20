import "dart:convert";
import "package:groq/groq.dart";
import "package:lg_kiss_app/services/action_service.dart";
import "package:shared_preferences/shared_preferences.dart";
String extractJson(String raw){
  raw=raw.trim();
  final regex=RegExp(r'```json\s*([\s\S]*?)```',multiLine:true);
  final match=regex.firstMatch(raw);
  if(match!=null){
    raw=match.group(1)!;
  }
  return raw.trim();
}
class GroqService {
  String template(String userPrompt)=>'''You are an expert Google Earth controller. You will be given a user's request and you will have to carry it out.
  Currently you can perform the following actions:"reboot","relaunch","shutdown","clearKML","setLogo","removeLogo".
  Remember clearing the logo is different from clearing the KML.
  The user may ask for tours, itineraries, orbits, give you commands and ask you general questions. 
  In case of general questions try to find out the geographical region that would pertain to the question.
  In case of multiple such places, make a tour. For each such point singilural or plural return a place object along with the action.
  If the user asks for a tour or an itinerary or something similar, act as an expert travel planner and make sure to include populolar places of interest, good places to eat, hidden gems etc.
  For itineraries also include hotels and estimated costs. For tours put each point in the tour in place array and add descriptions fot each place.
  In case of general information/ questions / tours /itineraries or anything requiring a set of places the action should be setPlacemark.
  Also for each place give detailed information atleast 50 words about the place as well as the question.
  You have been asked to do ${userPrompt} by the user.Format your reply in json format. Return only the json and no other text.
  The format of json is as follows {"actions":[{"action":"name of action","place":[{"name":name,"latitude":latitude,"longitude":longitude,"details":details}]}....]]}.
  ''';
  late Groq _groq; 
  
  Future<void> init()async{
    print("gemma init");
    SharedPreferences data=await SharedPreferences.getInstance();
  String _apiKey= data.getString('_apiKey')??'APIKEY';
   _groq=Groq(apiKey:_apiKey,model:'gemma2-9b-it');
  _groq.startChat();
  }
  Future<String?> sendGemma(String prompt) async{
    print("called");
    try{
      final GroqResponse response=await _groq.sendMessage(template(prompt));
      print(response);
      Map<String,dynamic> parsed=jsonDecode(extractJson(response.choices.first.message.content));
      print(parsed);
      handleAIResponse(parsed);
      return extractJson(response.choices.first.message.content); 

    }on GroqException catch(e){
      print('GroqException ${e.message}');
      return null;
    }catch(e){
      print("Promblem while sending to Gemma ${e}");
      return null;
    }
  }
}