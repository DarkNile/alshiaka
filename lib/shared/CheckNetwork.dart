import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CheckNetwork extends StatefulWidget {
  final Widget child;
  const CheckNetwork({required this.child});
  @override
  _NetworkIndicatorState createState() => _NetworkIndicatorState();
}

class _NetworkIndicatorState extends State<CheckNetwork> {
  double _height = 0;

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: _height * 0.2,
            ),
            Icon(
              Icons.signal_wifi_off,
              size: _height * 0.25,
              color: Colors.grey[300],
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "sorry..no_internet_connection".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )),
            SizedBox(
              height: 30,
            ),
            Container(
                height: _height * 0.09,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.25,
                    vertical: _height * 0.02),
                child: Builder(
                    builder: (context) => ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(500),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0))),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          child: InkWell(
                            onTap: () {
                              print(
                                  "000000000000000000000000000000000000000000000000000");
                              Widget.canUpdate(widget, build(context));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "refresh_screen".tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.0),
                                )),
                          ),
                        )))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          final appBar = AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'ap'.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DinNext',
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
          );
          _height = MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top;
          return Scaffold(
            appBar: appBar,
            body: _buildBodyItem(),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return widget.child;
      },
    );
  }
}
