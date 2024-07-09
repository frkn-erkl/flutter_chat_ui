import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../models/bubble_rtl_alignment.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar(
      {super.key,
      required this.author,
      this.bubbleRtlAlignment,
      this.imageHeaders,
      this.onAvatarTap,
      required this.isnewuser,
      required this.isgendermale,
      required this.starnumber,
      this.clr
      // required this.isnewuser
      });

  /// Author to show image and name initials from.
  final types.User author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;
  final bool isnewuser;
  final bool isgendermale;
  final int starnumber;
  final Color? clr;

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
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          onAvatarTap?.call(author, details.globalPosition);
        },
        child: Stack(children: [
          Container(
            width: 41,
            height: 45,
            color: Colors.transparent,
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 41,
              height: 45,
              child: Transform.rotate(
                angle: pi / (0.175 * starnumber),
                child: Stack(
                  children: List.generate(
                    starnumber,
                    (index) => Positioned(
                      left: 13.3 + 16 * cos(2 * pi * index / starnumber),
                      top: 13.3 + 16 * sin(2 * pi * index / starnumber),
                      child: Icon(
                        Icons.star,
                        size: 8.0,
                        color: clr == null
                            ? Color.fromARGB(255, 205, 187, 27)
                            : clr,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 11.5,
            top: 5.5,
            child: CircleAvatar(
             /*  backgroundColor: hasImage
                  ? InheritedChatTheme.of(context)
                      .theme
                      .userAvatarImageBackgroundColor
                  : color, */
                   backgroundColor: isgendermale
                  ? Colors.blue
                  : Colors.pink,
              backgroundImage: hasImage
                  ? NetworkImage(author.imageUrl!, headers: imageHeaders)
                  : null,
              radius: 12.5,
              child: !hasImage
                  ? Text(
                      initials,
                      style: InheritedChatTheme.of(context)
                          .theme
                          .userAvatarTextStyle,
                    )
                  : null,
            ),
          ),
          if (isnewuser)
            Positioned(
              left: 9,
              bottom: 5,
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

class StarCircle extends StatelessWidget {
  final int numberOfStars = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Stack(
        children: List.generate(
          numberOfStars,
          (index) => Positioned(
            left: 100 + 80 * cos(2 * pi * index / numberOfStars),
            top: 100 + 80 * sin(2 * pi * index / numberOfStars),
            child: Icon(
              Icons.star,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
