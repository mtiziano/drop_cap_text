library drop_cap_text;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum DropCapMode {
  /// default
  inside,
  upwards,
  aside,

  /// Does not support dropCapPadding, indentation, dropCapPosition and custom dropCap.
  /// Try using DropCapMode.upwards in combination with dropCapPadding and forceNoDescent=true
  baseline
}

enum DropCapPosition {
  start,
  end,
}

class DropCap extends StatelessWidget {
  final Widget child;
  final double width, height;

  DropCap({
    Key key,
    this.child,
    @required this.width,
    @required this.height,
  })  : assert(width != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: child, width: width, height: height);
  }
}

class DropCapText extends StatelessWidget {
  final String data;
  final DropCapMode mode;
  final TextStyle style, dropCapStyle;
  final TextAlign textAlign;
  final DropCap dropCap;
  final EdgeInsets dropCapPadding;
  final Offset indentation;
  final bool forceNoDescent;
  final TextDirection textDirection;
  final DropCapPosition dropCapPosition;
  int dropCapChars;

  DropCapText(this.data,
      {Key key,
      this.mode = DropCapMode.inside,
      this.style,
      this.dropCapStyle,
      this.textAlign,
      this.dropCap,
      this.dropCapPadding = EdgeInsets.zero,
      this.indentation = Offset.zero,
      this.dropCapChars = 1,
      this.forceNoDescent = false,
      this.textDirection = TextDirection.ltr,
      this.dropCapPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      height: 1,
      fontFamily: Theme.of(context)?.textTheme?.body1?.fontFamily,
    ).merge(style);

    if (data == '') return Text(data, style: textStyle);

    TextStyle capStyle = TextStyle(
      color: textStyle.color,
      fontSize: textStyle.fontSize * 5.5,
      fontFamily: textStyle.fontFamily,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      height: 1,
    ).merge(dropCapStyle);

    TextPainter textPainter = TextPainter(
      textDirection: textDirection,
      text: TextSpan(
        text: data.substring(1),
        style: textStyle.apply(fontSizeFactor: MediaQuery.of(context).textScaleFactor),
      ),
    );

    double capWidth, capHeight;
    double lineHeight = textPainter.preferredLineHeight;
    CrossAxisAlignment sideCrossAxisAlignment = CrossAxisAlignment.start;

    if (mode == DropCapMode.baseline && dropCap == null) return _buildBaseline(context, textStyle, capStyle);

    // custom DropCap
    if (dropCap != null) {
      capWidth = dropCap.width;
      capHeight = dropCap.height;
      dropCapChars = 0;
    } else {
      TextPainter capPainter = TextPainter(
        text: TextSpan(text: data.substring(0, dropCapChars), style: capStyle),
        textDirection: textDirection,
      );
      capPainter.layout();
      capWidth = capPainter.width;
      capHeight = capPainter.height;
      if (forceNoDescent) {
        List<LineMetrics> ls = capPainter.computeLineMetrics();
        capHeight -= ls.isNotEmpty ? ls[0].descent * 0.95 : capPainter.height * 0.2;
      }
    }

    // compute drop cap padding
    capWidth += dropCapPadding.left + dropCapPadding.right;
    capHeight += dropCapPadding.top + dropCapPadding.bottom;

    // int rows = ((capHeight - indentation.dy) / lineHeight).floor();
    int rows = ((capHeight - indentation.dy) / lineHeight).ceil();

    // DROP CAP MODE - UPWARDS
    if (mode == DropCapMode.upwards) {
      rows = 1;
      sideCrossAxisAlignment = CrossAxisAlignment.end;
    }

    // BUILDER
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      double boundsWidth = constraints.maxWidth - capWidth;
      if (boundsWidth < 1) boundsWidth = 1;

      int charIndexEnd = data.length;

      int startMillis = new DateTime.now().millisecondsSinceEpoch;
      if (rows > 0) {
        textPainter.layout(maxWidth: boundsWidth);
        // double yPos = (rows + 1) * lineHeight;
        double yPos = rows * lineHeight;
        int charIndex = textPainter.getPositionForOffset(Offset(0, yPos)).offset;
        textPainter.maxLines = rows;
        textPainter.layout(maxWidth: boundsWidth);
        if (textPainter.didExceedMaxLines) charIndexEnd = charIndex;
      } else {
        charIndexEnd = dropCapChars;
      }
      int totMillis = new DateTime.now().millisecondsSinceEpoch - startMillis;

      // DROP CAP MODE - LEFT
      if (mode == DropCapMode.aside) charIndexEnd = data.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Text(totMillis.toString() + ' ms'),
          Row(
            // textDirection: dropCapPosition != null ? (dropCapPosition == DropCapPosition.start?) : textDirection,
            textDirection: dropCapPosition == null || dropCapPosition == DropCapPosition.start
                ? textDirection
                : (textDirection == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr),
            crossAxisAlignment: sideCrossAxisAlignment,
            children: <Widget>[
              dropCap != null
                  ? Padding(padding: dropCapPadding, child: dropCap)
                  : Container(
                      width: capWidth,
                      height: capHeight,
                      padding: dropCapPadding,
                      child: RichText(
                        textDirection: textDirection,
                        text: TextSpan(
                          text: data.substring(0, dropCapChars),
                          style: capStyle,
                        ),
                      ),
                    ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: indentation.dy),
                  height: (lineHeight * rows) + indentation.dy,
                  child: Text(
                    // data.substring(dropCapChars, charIndexEnd),
                    data.substring(dropCapChars, data.length), //min(charIndexEnd + 10, data.length)
                    style: textStyle,
                    textAlign: textAlign,
                    textDirection: textDirection,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: indentation.dx),
            child: Text(
              data.substring(charIndexEnd).trim(),
              style: textStyle,
              textAlign: textAlign,
              textDirection: textDirection,
            ),
          ),
        ],
      );
    });
  }

  _buildBaseline(BuildContext context, TextStyle textStyle, TextStyle capStyle) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        // style: TextStyle(color: Colors.black),
        style: textStyle,
        children: <TextSpan>[
          TextSpan(
            text: data.substring(0, dropCapChars),
            style: capStyle.merge(TextStyle(height: 0)),
          ),
          TextSpan(
            text: data.substring(dropCapChars),
            style: textStyle.apply(fontSizeFactor: MediaQuery.of(context).textScaleFactor),
          ),
        ],
      ),
    );
  }
}
