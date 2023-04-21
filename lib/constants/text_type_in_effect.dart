import 'dart:async';

import 'package:flutter/material.dart';

class TextEffect extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final TextAlign textAlign;
  final TextOverflow overflow;

  const TextEffect(
      {Key? key,
      required this.text,
      this.style = const TextStyle(fontSize: 18.0),
      this.delay = const Duration(milliseconds: 50),
      this.textAlign = TextAlign.left,
      this.overflow = TextOverflow.clip})
      : super(key: key);

  @override
  _TextEffectState createState() => _TextEffectState();
}

class _TextEffectState extends State<TextEffect> {
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _animateText();
  }

  Future<void> _animateText() async {
    for (int i = 0; i <= widget.text.length; i++) {
      await Future.delayed(widget.delay);
      if (mounted) {
        setState(() {
          _displayText = widget.text.substring(0, i);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
    );
  }
}
