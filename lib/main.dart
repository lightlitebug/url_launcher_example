import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void showErrorDialog(String errMsg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('실패'),
          content: Text(errMsg),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('다시 시도하세요'),
            ),
          ],
        );
      },
    );
  }

  void launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      showErrorDialog('브라우저에서 $url 열기 실패!');
    }
  }

  void launchInWebViewOrSafariVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      showErrorDialog('앱 내에서 $url 열기 실패!');
    }
  }

  void launchInEmailClient(String emailScheme) async {
    if (await canLaunch(emailScheme)) {
      await launch(emailScheme);
    } else {
      showErrorDialog('이메일 클라이언트에서 $emailScheme 열기 실패!');
    }
  }

  void makePhoneCall(String phoneScheme) async {
    if (await canLaunch(phoneScheme)) {
      await launch(phoneScheme);
    } else {
      showErrorDialog('전화걸기 실패!');
    }
  }

  void sendSMS(String smsScheme) async {
    if (await canLaunch(smsScheme)) {
      await launch(smsScheme);
    } else {
      showErrorDialog('문자 보내기 실패!');
    }
  }

  void launchUniversalLinkIos(String url) async {
    final canLaunchVal = await canLaunch(url);
    print('canLauchVal: $canLaunchVal');

    if (canLaunchVal) {
      final bool launchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      print('launchedSucceeded: $launchSucceeded');
      if (!launchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const String url = 'https://en.wikipedia.org/wiki/Galaxy';

    return Scaffold(
      appBar: AppBar(
        title: Text('URL Launcher'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Text(
                  url,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('브라우저에서 열기'),
                  onPressed: () => launchInBrowser(url),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('웹뷰 / 사파리뷰 컨트롤러'),
                  onPressed: () => launchInWebViewOrSafariVC(url),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('메일 보내기'),
                  onPressed: () => launchInEmailClient('mailto:'),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('전화 걸기'),
                  onPressed: () => makePhoneCall('tel:'),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('문자 보내기'),
                  onPressed: () => sendSMS('sms:'),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('유니버설 링크 열기'),
                  onPressed: () =>
                      launchUniversalLinkIos('https://www.youtube.com'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
