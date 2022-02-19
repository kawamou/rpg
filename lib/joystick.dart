import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class JoystickController extends JoystickComponent {
  JoystickController(Paint knobPaint, Paint backgroundPaint)
      : super(
            background: CircleComponent(radius: 100, paint: backgroundPaint),
            knob: CircleComponent(radius: 30, paint: knobPaint),
            margin: const EdgeInsets.only(left: 40, bottom: 40));
}
