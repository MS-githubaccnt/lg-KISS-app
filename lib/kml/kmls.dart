import 'package:lg_kiss_app/entity/look_at.dart';

String openLogoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>Liquid Galaxy Lab</name>
	<open>1</open>
	<description>Logo for Liquid Galaxy Task</description>
	<Folder>
		<name>Logo</name>
		<Style>
			<ListStyle>
				<listItemType>checkHideChildren</listItemType>
				<bgColor>00ffffff</bgColor>
				<maxSnippetLines>2</maxSnippetLines>
			</ListStyle>
		</Style>
		<ScreenOverlay id="Logo">
			<name>Liquid Galaxy</name>
			<Icon>
				<href>https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXmdNgBTXup6bdWew5RzgCmC9pPb7rK487CpiscWB2S8OlhwFHmeeACHIIjx4B5-Iv-t95mNUx0JhB_oATG3-Tq1gs8Uj0-Xb9Njye6rHtKKsnJQJlzZqJxMDnj_2TXX3eA5x6VSgc8aw/s320-rw/LOGO+LIQUID+GALAXY-sq1000-+OKnoline.png</href>
			</Icon>
			<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
			<screenXY x="0" y="0.98" xunits="fraction" yunits="fraction"/>
			<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
			<size x="0" y="0" xunits="pixels" yunits="fraction"/>
		</ScreenOverlay>
	</Folder>
</Document>
</kml>
  ''';
  String blankKml = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  </Document>
</kml>''';
String kmltwo='''
    <Placemark>
      <name>Blue Star in Mumbai</name>
      <Style>
        <IconStyle>
          <color>ffff0000</color>
          <Icon>
            <href>http://maps.google.com/mapfiles/kml/shapes/star.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Point>
        <coordinates>72.8777,19.0760,0</coordinates>
      </Point>
    </Placemark>

''';

String kmlone='''
    <Placemark>
      <name>Eiffel Tower in Paris</name>
      <Style>
        <IconStyle>
          <color>ffff0000</color>
          <Icon>
            <href>http://maps.google.com/mapfiles/kml/shapes/star.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Point>
        <coordinates>2.2945,48.8584,0</coordinates>
      </Point>
    </Placemark>

''';
  String emptyBalloon() {
    return '''<?xml version="1.0" encoding="UTF-8"?>
    <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
      <Document>
       <name>None</name>
       <Style id="blank">
         <BalloonStyle>
           <textColor>ffffffff</textColor>
           <text><font size="+2"></font></text>
           <bgColor>ff15151a</bgColor>
         </BalloonStyle>
       </Style>
       <Placemark id="bb">
         <description></description>
         <styleUrl>#blank</styleUrl>
         <gx:balloonVisibility>0</gx:balloonVisibility>
         <Point>
           <coordinates>0,0,0</coordinates>
         </Point>
       </Placemark>
      </Document>
    </kml>''';
  }
LookAtEntity look_at = LookAtEntity(
  lng: 2.2945,
  lat: 48.8584,
  range: 500,
  tilt: 45,
  heading: 180
);
LookAtEntity look_at_mumbai = LookAtEntity(
  lng: 72.8777,
  lat: 19.0760,
  range: 500,
  tilt: 45,
  heading: 180
);