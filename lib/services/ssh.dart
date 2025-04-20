import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_kiss_app/entity/kml_entity.dart';
import 'package:lg_kiss_app/entity/look_at.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lg_kiss_app/kml/kmls.dart';
import 'dart:async';
class LGSSHConnection{
  late String _ipAddress;
  late String _username;
  late String _password;
  String _numberOfRigs='0';
  late String _portNumber;
  late SSHClient? _client;
  int get _rightScreen{
   return (int.parse(_numberOfRigs)/2).floor()+1;
  }
  Future<void>_getConnection() async{
    SharedPreferences data=await SharedPreferences.getInstance();
     _ipAddress= data.getString('ip')??'localhost';
     _username= data.getString('username')??'lg';
     _password= data.getString('password')??'lg';
     _numberOfRigs= data.getString('numberOfRigs')??'3';
     _portNumber= data.getString('portNumber')??'22';
  }
  Future<void> _ensureInitialize()async{
    if(_numberOfRigs.isEmpty||_numberOfRigs=="0")await _getConnection();
  }
  int rigs(){
    return int.parse(_numberOfRigs);
  }
   String generateBlank(String id) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="$id">
  </Document>
</kml>
    ''';
  }
  Future<bool?> connectToLG() async {

    await _getConnection();
    try{
      _client=SSHClient(
        await SSHSocket.connect(_ipAddress,
         int.parse(_portNumber)),
        username: _username,
        onPasswordRequest:()=>_password,
        );
        return true;
      }catch(e){
        print("failed to connect ${e}");
        return false;
      }
  }
  checkConnection()async{
    bool? check=await connectToLG();
    await _disconnectLG();
    if(check==true){
      return true;
    }else{
      return false;
    }
  }
  _disconnectLG()async{
    if(_client!=null){
    _client!.close();
    await _client!.done;}
  }
  Future<SSHSession?> _createCommandSession(String command)async{
    await connectToLG();
      try{
        if(_client==null){
          print("Initalise SSh CLient");
          return null;
        }else{
          final execResult=await _client!.execute(command);
          return execResult;
      }
      }catch(e){
        print('Error ${e}');
        return null;
      }
  }
  runCommand(String command)async{
    final session=await _createCommandSession(command);
    if(session!=null){
    await session.done;
   await _disconnectLG();
   }
  }
  rebootLG()async{
    try{
      for(var i=0;i<=int.parse(_numberOfRigs);i++){
        await runCommand('sshpass -p ${_password} ssh -t lg$i "echo ${_password} | sudo -S reboot"');
      }

    }catch(e){
      print("Error in shutting down $e");
    }
  }
  shutdownLG()async{
    try{
      for(var i=0;i<=int.parse(_numberOfRigs);i++){
        await runCommand('sshpass -p ${_password} ssh -t lg$i "echo ${_password} | sudo -S poweroff"');
      }

    }catch(e){
      print("Error in shutting down $e");
    }
  }
  relaunchLG()async{
    String cmd = """RELAUNCH_CMD="\\if [ -f /etc/init/lxdm.conf ]; then
     export SERVICE=lxdm
   elif [ -f /etc/init/lightdm.conf ]; then
     export SERVICE=lightdm
   else
     exit 1
   fi
   if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
     echo $_password | sudo -S service \\\${SERVICE} start
   else
     echo $_password | sudo -S service \\\${SERVICE} restart
   fi
   " && sshpass -p $_password ssh -x -t lg@lg1 "\$RELAUNCH_CMD\"""";
   await runCommand(cmd);
  }
  //wrong rn
  orbitLocation(KMLEntity kml, LookAtEntity lookAt)async{
    await sendKmlnew(kml);
    await runCommand('echo "playtour=Orbit">/tmp/query.txt');
  }
  playOrbit(String filename)async{
    try{
      await runCommand('echo "playtour=$filename" > /tmp/query.txt');
    }
    catch(e){
      print("Error in playing orbit $e");
    }
  }
  clearKml()async{
    try{
      await runCommand('echo "exittour=true" > /tmp/query.txt');
      await runCommand("echo > /var/www/html/kmls.txt");
      for(var i=2;i<=int.parse(_numberOfRigs);i++){
        String blankKml =generateBlank('slave_$i');
        await runCommand("echo '$blankKml' > /var/www/html/kml/slave_$i.kml");
      }
    }
    catch(e){
      print("Error in clearing KMLs");
    }

  }
  setLogo()async{
        await _ensureInitialize();
      try{
      var rig=(int.parse(_numberOfRigs)/2).floor()+2;
      await runCommand("echo '$openLogoKML' > /var/www/html/kml/slave_${rig.toString()}.kml");
      print("Connected to send Logo"); }
      catch(e){
        print("Problem setting Logo");
        print(e);
      }
    }
  removeLogo()async{
      var rig=(int.parse(_numberOfRigs)/2).floor()+2;
      try{
        await runCommand("echo '$blankKml' > /var/www/html/kml/slave_${rig.toString()}.kml");

      }catch(e){
        print("Error removing Logos $e");
      }
    }
    buildOrbit(String content,String filename)async{
     File file= await createFile(filename, content);
     await useSftp(file.path, filename);
     await runCommand('echo "http://lg1:81/${filename}.kml" > /var/www/html/kmls.txt');
     print('orbit kml sent');
     //KMLEntity kml=KMLEntity(name: filename, content: content);
    }
    createFile(String name, String content)async{
      final dir=await getApplicationDocumentsDirectory();
      final file=File('${dir.path}/$name');
      file.writeAsStringSync(content);
      return file;
    }
    useSftp(String kmlPath,String name)async{
      await connectToLG();
      if (_client!=null){
      final sftp=await _client!.sftp();
      //check
      final file=await sftp.open('/var/www/html/$name.kml',mode:SftpFileOpenMode.create|SftpFileOpenMode.write);
      await file.write(File(kmlPath).openRead().cast(),
      onProgress:(progress){
        print(progress);
      });
      await _disconnectLG();
      }
      else{
        print ("client error");
      }
    }
    sendKmlnew(KMLEntity kml)async{
      final fileName='${kml.name}.kml';
      final kmlFile=await createFile(fileName, kml.body) as File;
      await useSftp(kmlFile.path,kml.name);
      await runCommand('echo "http://lg1:81/$fileName" > /var/www/html/kmls.txt');
      // await runCommand('flytoview=${lookat}')
    }
    sendKmlandFly(KMLEntity kml,LookAtEntity lookat)async{
      await sendKmlnew(kml);
      await runCommand("echo 'flytoview=${lookat.linearTag}'>/tmp/query.txt");
    }
    showBalloon(String kml)async{
    try {
      await cleanBalloon();
      await runCommand(
          "chmod 777 /var/www/html/kml/slave_$_rightScreen.kml; echo '' > /var/www/html/kml/slave_$_rightScreen.kml");
      final file = DateTime.now().millisecondsSinceEpoch.toString();
      final kmlFile = await createFile(file, kml);
      await useSftp(kmlFile.path,file);
      await runCommand('cat /var/www/html/$file > /var/www/html/kml/slave_$_rightScreen.kml');
    } on Exception catch(e){
      print(e);
    }
  }

  Future<void> cleanBalloon() async {
    await runCommand(
        "chmod 777 /var/www/html/kml/slave_$_rightScreen.kml; echo '${emptyBalloon()}' > /var/www/html/kml/slave_$_rightScreen.kml");
  }
    
}