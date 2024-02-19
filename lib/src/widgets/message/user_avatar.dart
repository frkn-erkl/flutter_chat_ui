import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/bubble_rtl_alignment.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.imageHeaders,
    this.onAvatarTap,
    required this.isnewuser,
    // required this.isnewuser
  });

  /// Author to show image and name initials from.
  final types.User author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;
  final bool isnewuser;

  /// Called when user taps on an avatar.
  final void Function(types.User, Offset position)? onAvatarTap;
  // final bool isnewuser;

  @override
  Widget build(BuildContext context) {
    final color = getUserAvatarNameColor(
      author,
      InheritedChatTheme.of(context).theme.userAvatarNameColors,
    );
    final hasImage = author.imageUrl != null;
    final initials = getUserInitials(author);

    return Container(
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? const EdgeInsetsDirectional.only(end: 0)
          : const EdgeInsets.only(right: 0),
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          onAvatarTap?.call(author, details.globalPosition);
        },
        child: Stack(children: [
          CircleAvatar(
            backgroundColor: hasImage
                ? InheritedChatTheme.of(context)
                    .theme
                    .userAvatarImageBackgroundColor
                : color,
            backgroundImage: hasImage
                ? NetworkImage(author.imageUrl!, headers: imageHeaders)
                : null,
            radius: 16,
            child: !hasImage
                ? Text(
                    initials,
                    style: InheritedChatTheme.of(context)
                        .theme
                        .userAvatarTextStyle,
                  )
                : null,
          ),
          if (isnewuser)
            Positioned(
              left: 1,
              bottom: 0,
              child: Container(
                width: 30, // Container genişliği
                height: 10, // Container yüksekliği
                decoration: BoxDecoration(
                  color: Colors.blue, // Arka plan rengi
                  borderRadius:
                      BorderRadius.circular(4.0), // Köşeleri oval yapar
                ),
                child: Center(
                  child: Text(
                    'Yeni',
                    style: TextStyle(
                      color: Colors.white, // Yazı rengi
                      fontSize: 8, // Yazı boyutu
                    ),
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: Center(
              child: SizedBox.expand(
                child: CustomPaint(
                  painter: StarCirclePainter(18, 15),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/* 
     if (isnewuser)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 50, // Container genişliği
                height: 20, // Container yüksekliği
                decoration: BoxDecoration(
                  color: Colors.blue, // Arka plan rengi
                  borderRadius:
                      BorderRadius.circular(8.0), // Köşeleri oval yapar
                ),
                child: Center(
                  child: Text(
                    'Yeni',
                    style: TextStyle(
                      color: Colors.white, // Yazı rengi
                      fontSize: 12, // Yazı boyutu
                    ),
                  ),
                ),
              ),
            )
 */

class StarCirclePainter extends CustomPainter {
  final int starCount;
  final double radius;

  StarCirclePainter(this.starCount, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double angleIncrement = 2 * pi / starCount;

    for (int i = 0; i < starCount; i++) {
      double x = centerX + radius * cos(i * angleIncrement);
      double y = centerY + radius * sin(i * angleIncrement);

      // Yıldız İkonu (Icon sınıfı kullanılarak)
      canvas.drawCircle(
        Offset(x, y),
        20.0, // Yıldızın çapı
        Paint()..color = Colors.yellow,
      );

      // Yıldız İkonu (SvgPicture kullanılarak)
      Positioned(
        left: x - 15.0,
        top: y - 15.0,
        child: SvgPicture.asset(
          'assets/icon-x.png', // Svg dosyanızın yolunu güncelleyin
          color: Colors.black,
          width: 30.0, // İkonun genişliği
          height: 30.0, // İkonun yüksekliği
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
