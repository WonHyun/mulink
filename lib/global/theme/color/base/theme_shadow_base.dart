import 'package:flutter/material.dart';

abstract class ThemeShadowBase {
  const ThemeShadowBase();

  BoxShadow get buttonShadow;

  BoxShadow get buttonShadowSmall;

  BoxShadow get textShadow;

  BoxShadow get defaultShadow;

  BoxShadow get thickTextShadow;
}
