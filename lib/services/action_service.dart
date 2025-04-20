import 'package:lg_kiss_app/models/place.dart';
import 'package:lg_kiss_app/services/orbit_service.dart';
import 'package:lg_kiss_app/services/ssh.dart';

Future<void>  handleAIResponse(Map<String,dynamic> parsed) async {
  LGSSHConnection  _lg=LGSSHConnection();
  syncBalloonsWithTour(List<Place> places)async{
  int delay = 2;
  for(int i=0;i<places.length;i++){
    final balloonKML=Orbit().generateBalloon(places[i]);
    await Future.delayed(Duration(seconds:delay),()async{
      await _lg.showBalloon(balloonKML);
      print("Balloon for ${places[i].name} shown at ${delay}s");
    });
    delay += 20;
  }
}
  final Map<String,Future<void> Function()> asyncFuncMap={
    'reboot':()async=>await _lg.rebootLG(),
    'relaunch':()async=>await _lg.relaunchLG(),
    'shutdown':()async=>await _lg.shutdownLG(),
    'clearKML':()async=>await _lg.clearKml(),
    'setLogo':()async=>await _lg.setLogo(),
    'removeLogo':()async=>await _lg.removeLogo(),
  };
  for(final actionObject in parsed['actions']){
    if(actionObject['action']=='setPlacemark'){
      List<Place> places=[];
      for(final place in actionObject['place']){
        Place placeExtracted=Place(name: (place['name'] as String).toLowerCase(), details: place['details'], latitude:(place['latitude'] as num).toDouble(), longitude: (place['longitude'] as num).toDouble());
        places.add(placeExtracted);
      }
      String placesdata=Orbit().generateOrbit(places);
      String filename=places[0].name.toLowerCase();
      String content=Orbit().buildOrbit(placesdata, places, filename);
      print(content);
      await _lg.buildOrbit(content, filename);
      await Future.delayed(Duration(seconds: 3)); 
      await _lg.playOrbit(filename); 
   //   await syncBalloonsWithTour(places);    

    }else{
    await asyncFuncMap[actionObject['action']]?.call();}
  }

}
