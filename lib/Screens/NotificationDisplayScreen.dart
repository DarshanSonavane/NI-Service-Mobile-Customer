import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ni_service/Screens/MediaDisplayScreen.dart';

import '../http_service/services.dart';
import '../model/ResponseNotificationList.dart';

class Notificationdisplayscreen extends StatefulWidget {
  static const String routeName = '/notification_display';
  final String title;

  const Notificationdisplayscreen({Key? key, required this.title})
      : super(key: key);

  @override
  State<Notificationdisplayscreen> createState() =>
      _NotificationdisplayscreenState();
}

class _NotificationdisplayscreenState extends State<Notificationdisplayscreen> {
  late Future<ResponseNotificationList> futureNotifications;
  final double _borderRadius = 24;

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchNotifications();
  }

  void _onArrowIconPressed(String base64Data, bool isVideo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Mediadisplayscreen(
          base64Data: base64Data,
          isVideo: isVideo,
          title: 'Media'
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<ResponseNotificationList>(
        future: futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load notifications'));
          } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
            return const Center(child: Text('No notifications available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data!.data![index];
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12.0),
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_borderRadius),
                        gradient: const LinearGradient(
                            colors: [
                              Colors.lightGreen,
                              Colors.lightGreenAccent
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 12,
                              offset: Offset(0, 6)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.6, // 60% of the width
                              child: Text(
                                notification.notes ?? 'No notes available',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8.5,
                      bottom: 12,
                      top: 8.5,
                      child: CustomPaint(
                        size: const Size(100, 150),
                        painter: CustomCardShapePainter(
                            _borderRadius, Colors.yellowAccent),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30, bottom: 30),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () => _onArrowIconPressed(
                              notification.file!,
                              notification.extension == 'mp4' ? true : false,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.pinkAccent,
                              size: 40.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        const Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(const Color(0xFFFFC90F)).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
